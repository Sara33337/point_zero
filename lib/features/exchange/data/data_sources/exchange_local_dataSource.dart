import 'package:point_zero/core/data/db_helper.dart';
import 'package:point_zero/features/exchange/data/models/past_sale_model.dart';
import 'package:point_zero/features/exchange/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/inventory/data/models/product_model.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';



abstract class ExchangeLocalDatasource {
  Future<List<PastSaleItemModel>> searchPastSales(String query);
  Future<List<ProductModel>> searchProducts(String query);

  Future<void> processExchangeTransaction({
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
    WHERE bi.product_code LIKE ? OR bi.product_name LIKE ?
    ORDER BY b.created_at DESC
    ''',
      ['%$query%', '%$query%'],
    );

    // 👈 هنا بنعمل التحويل من Map لـ Model
    return results.map((map) => PastSaleItemModel.fromMap(map)).toList();
  }

  @override
  @override
  Future<void> processExchangeTransaction({
    required PastSaleItemEntity returnedItem, 
    required List<CartItemModel> replacementItems,
    required double differencePaid,
  }) async {
    final db = await dbHelper.database;

    await db.transaction((txn) async {
      // 1. ترجيع المنتج القديم للمخزن
      await txn.rawUpdate(
        '''
      UPDATE products 
      SET stock_quantity = stock_quantity + ? 
      WHERE code = ?
      ''',
        [returnedItem.quantity, returnedItem.productCode],
      );

      // 2. سحب المنتجات البديلة من المخزن
      for (var item in replacementItems) {
        await txn.rawUpdate(
          '''
        UPDATE products 
        SET stock_quantity = stock_quantity - ? 
        WHERE code = ?
        ''',
          [item.quantity, item.product.code],
        );
      }

      // 3. نكريت الفاتورة الجديدة الأول عشان ناخد الـ ID بتاعها
      int newBillId = await txn.insert('bills', {
        'total_amount': differencePaid,
        'created_at': DateTime.now().toIso8601String(),
        'is_exchange': 1,
      });

      // 4. نضيف المنتجات البديلة للفاتورة الجديدة
      for (var item in replacementItems) {
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

      await txn.insert('exchanges', {
        'old_bill_id': returnedItem.billId,
        'new_bill_id': newBillId, // 👈 الربط حصل هنا بنجاح
        'old_product_code': returnedItem.productCode,
        'old_product_name': returnedItem.productName,
        'returned_qty': returnedItem.quantity,
        'return_credit': returnedItem.unitPrice * returnedItem.quantity, // 👈 ضفنا فلوس المرتجع هنا
        'difference_paid': differencePaid,
        'created_at': DateTime.now().toIso8601String(),
      });
      
    });
  }
  
  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final db = await dbHelper.database; 
  final List<Map<String, dynamic>> maps = await db.query(
    'products', 
    where: 'name LIKE ? OR code LIKE ?',
    whereArgs: ['%$query%', '%$query%'],
  );

  // تحويل النتائج من Map إلى قائمة من ProductModel
  return List.generate(maps.length, (i) {
    return ProductModel.fromMap(maps[i]); 
  });
  }
}