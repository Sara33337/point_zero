import 'package:equatable/equatable.dart';

class ExpenseEntity extends Equatable {
  final int? id;
  final String expenseName;
  final double expenseAmount;
  final DateTime date;
  const ExpenseEntity({
    this.id,
    required this.expenseAmount,
    required this.expenseName,
    required this.date,
  });
  @override
  List<Object?> get props => [id, expenseAmount, expenseName, date];
}
