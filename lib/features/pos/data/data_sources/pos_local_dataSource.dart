import 'package:point_zero/core/data/db_helper.dart';

import 'package:point_zero/core/errors/exceptions.dart';
import 'package:point_zero/features/pos/data/models/bill_model.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';

abstract class PosLocalDataSource {
  Future<void> checkout(BillModel bill);
}

class PosLocalDataSourceImpl implements PosLocalDataSource {
  final DatabaseHelper dbHelper;

  PosLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<void> checkout(BillModel bill) async {
    final db = await dbHelper.database;

    try {
      await db.transaction((txn) async {
        final int billId = await txn.insert('bills', bill.toMap());
        for (final item in bill.items) {
          final itemModel = CartItemModel.fromEntity(item);

          await txn.insert('bill_items', itemModel.toMap(billId));

          final int newStock = item.product.stockQuantity - item.quantity;

          if (newStock < 0) {
            throw LocalDatabaseException(
              message:
                  'الكمية المطلوبة من ${item.product.name} غير متوفرة في المخزن',
            );
          }
          await txn.update(
            'products',
            {'stock_quantity': newStock},
            where: 'id = ?',
            whereArgs: [item.product.id],
          );
        }
      });
    } catch (e) {
      if (e is LocalDatabaseException) {
        rethrow;
      }
      throw LocalDatabaseException(
        message: 'فشل في إتمام عملية الدفع وحفظ الفاتورة.',
      );
    }
  }

}
