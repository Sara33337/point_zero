import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    super.id,
    required super.expenseAmount,
    required super.expenseName,
    required super.date,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as int?,
      expenseName: map['name'] as String,
      expenseAmount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      expenseAmount: entity.expenseAmount,
      expenseName: entity.expenseName,
      date: entity.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': expenseName,
      'amount': expenseAmount,
      'date': date.toIso8601String(),
    };
  }
}
