import 'package:point_zero/core/data/db_helper.dart';
import 'package:point_zero/core/errors/exceptions.dart';
import 'package:point_zero/features/exchange/data/models/past_sale_model.dart';
import 'package:point_zero/features/exchange/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/inventory/data/models/product_model.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';

abstract class ExchangeLocalDatasource {
  Future<List<PastSaleItemModel>> searchPastSales(String query);
  Future<List<ProductModel>> searchProducts(String query);

  Future<int> processExchangeTransaction({
    required PastSaleItemEntity returnedItem,
    required List<CartItemModel> replacementItems,
    required double differencePaid,
  });
}

class ExchangeLocalDatasourceImpl implements ExchangeLocalDatasource {
  final DatabaseHelper dbHelper;
  ExchangeLocalDatasourceImpl({required this.dbHelper});
@override
  Future<List<PastSaleItemModel>> searchPastSales(String query) async {
    final db = await dbHelper.database;
    final cleanQuery = query.replaceAll('#', '').trim();

    final List<Map<String, dynamic>> results = await db.rawQuery(
      '''
      SELECT 
        bi.bill_id, 
        bi.product_code, 
        bi.product_name, 
        bi.unit_price, 
        bi.quantity, 
        b.created_at 
      FROM bill_items bi
      JOIN bills b ON bi.bill_id = b.id
      WHERE bi.quantity > 0
        AND (
          CAST(b.id AS TEXT) LIKE ?
          OR bi.product_code LIKE ? 
          OR bi.product_name LIKE ?
        )
      ORDER BY b.created_at DESC
      ''',
      ['%$cleanQuery%', '%$cleanQuery%', '%$cleanQuery%'],
    );

    return results.map((map) => PastSaleItemModel.fromMap(map)).toList();
  }

  @override
  Future<int> processExchangeTransaction({
    required PastSaleItemEntity returnedItem,
    required List<CartItemModel> replacementItems,
    required double differencePaid,
  }) async {
    final db = await dbHelper.database;
    int? createdNewBillId;

    await db.transaction((txn) async {
      // 1. التحقق من سطر المنتج في الفاتورة القديمة وخصم الكمية المرتجعة
      final billItemRows = await txn.query(
        'bill_items',
        where: 'bill_id = ? AND product_code = ?',
        whereArgs: [returnedItem.billId, returnedItem.productCode],
      );

      

      if (billItemRows.isEmpty) {
        throw LocalDatabaseException();
      }

      final currentBillQty = billItemRows.first['quantity'] as int;
      final unitPrice = (billItemRows.first['unit_price'] as num).toDouble();

      if (returnedItem.quantity > currentBillQty) {
        throw LocalDatabaseException();
      }

      final remainingQty = currentBillQty - returnedItem.quantity;
      if (remainingQty == 0) {
        await txn.delete(
          'bill_items',
          where: 'bill_id = ? AND product_code = ?',
          whereArgs: [returnedItem.billId, returnedItem.productCode],
        );
      } else {
        await txn.rawUpdate(
          '''
          UPDATE bill_items
          SET quantity = ?, subtotal = ?
          WHERE bill_id = ? AND product_code = ?
          ''',
          [
            remainingQty,
            remainingQty * unitPrice,
            returnedItem.billId,
            returnedItem.productCode,
          ],
        );
      }

      // تحديث إجمالي الفاتورة القديمة بعد خصم قيمة المرتجع
      final returnedCredit = returnedItem.unitPrice * returnedItem.quantity;
      await txn.rawUpdate(
        '''
        UPDATE bills
        SET total_amount = CASE 
          WHEN total_amount - ? < 0 THEN 0 
          ELSE total_amount - ? 
        END
        WHERE id = ?
        ''',
        [returnedCredit, returnedCredit, returnedItem.billId],
      );

      // 2. إعادة المنتج المرتجع إلى المخزن
      await txn.rawUpdate(
        '''
        UPDATE products 
        SET stock_quantity = stock_quantity + ? 
        WHERE code = ?
        ''',
        [returnedItem.quantity, returnedItem.productCode],
      );

      // 3. سحب المنتجات البديلة من المخزن مع حماية من الرصيد السالب
      for (final item in replacementItems) {
        final updatedRows = await txn.rawUpdate(
          '''
          UPDATE products 
          SET stock_quantity = stock_quantity - ? 
          WHERE code = ? AND stock_quantity >= ?
          ''',
          [item.quantity, item.product.code, item.quantity],
        );

        if (updatedRows == 0) {
          throw LocalDatabaseException();
        }
      }

      // 4. إنشاء فاتورة الاستبدال الجديدة
     final int newBillId = await txn.insert('bills', {
        'total_amount': differencePaid,
        'created_at': DateTime.now().toIso8601String(),
        'is_exchange': 1,
      });
      createdNewBillId = newBillId;

      // 5. إضافة المنتجات البديلة للفاتورة الجديدة
      for (final item in replacementItems) {
        await txn.insert('bill_items', {
          'bill_id': newBillId,
          'product_code': item.product.code,
          'product_name': item.product.name,
          'quantity': item.quantity,
          'wholesale_price': item.product.wholesalePrice,
          'unit_price': item.unitPrice,
          'subtotal': item.subtotal,
        });
      }

      // 6. تسجيل حركة الاستبدال في جدول exchanges
      await txn.insert('exchanges', {
        'old_bill_id': returnedItem.billId,
        'new_bill_id': newBillId,
        'old_product_code': returnedItem.productCode,
        'old_product_name': returnedItem.productName,
        'returned_qty': returnedItem.quantity,
        'return_credit': returnedCredit,
        'difference_paid': differencePaid,
        'created_at': DateTime.now().toIso8601String(),
      });
    });

    return createdNewBillId!;
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name LIKE ? OR code LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return maps.map((map) => ProductModel.fromMap(map)).toList();
  }
}
