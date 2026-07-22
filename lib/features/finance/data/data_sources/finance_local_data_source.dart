import 'package:dartz/dartz.dart';
import 'package:point_zero/core/data/db_helper.dart';
import 'package:point_zero/features/finance/data/models/expense_model.dart';
import 'package:point_zero/features/pos/data/models/bill_model.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';

abstract class FinanceLocalDataSource {
  Future<Unit> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpenseByMonth(int month, int year);
  Future<List<BillModel>> getBillsByMonth(int month, int year);
}

class FinancrLocalDataSourceImpl implements FinanceLocalDataSource {
  final DatabaseHelper dbHelper;
  FinancrLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<Unit> addExpense(ExpenseModel expense) async {
    final db = await dbHelper.database;
    await db.insert('expenses', expense.toMap());
    return unit;
  }

  @override
  Future<List<BillModel>> getBillsByMonth(int month, int year) async {
    final db = await dbHelper.database;
    final String monthStr = month < 10 ? '0$month' : '$month';
    final String dateFilter = '$year-$monthStr%';

    // 1. بنجيب الفواتير الأساسية الأول (من جدول bills)
    final List<Map<String, dynamic>> billMaps = await db.query(
      'bills',
      where: 'created_at LIKE ?',
      whereArgs: [dateFilter],
    );

    List<BillModel> completeBills = [];

    for (var billMap in billMaps) {
      final int billId = billMap['id'] as int;

      final List<Map<String, dynamic>> itemMaps = await db.rawQuery(
        '''
        SELECT 
          bi.*, 
          p.selling_price AS original_price 
        FROM bill_items bi
        LEFT JOIN products p ON bi.product_code = p.code
        WHERE bi.bill_id = ?
        ''',
        [billId],
      );

      final items = itemMaps.map((item) => CartItemModel.fromMap(item)).toList();

      completeBills.add(
        BillModel(
          id: billId,
          totalAmount: (billMap['total_amount'] as num).toDouble(),
          createdAt: DateTime.parse(billMap['created_at']),
          items: items, 
        ),
      );
    }
    return completeBills;
  }

  @override
  Future<List<ExpenseModel>> getExpenseByMonth(int month, int year) async {
    final db = await dbHelper.database;
    final String monthStr = month < 10 ? '0$month' : '$month';
    final String dateFilter = '$year-$monthStr%';

    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'date LIKE ?',
      whereArgs: [dateFilter],
    );

    return maps.map((map) => ExpenseModel.fromMap(map)).toList();
  }
}
