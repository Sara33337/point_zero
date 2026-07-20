import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

abstract class FinanceRepository {
  Future<Either<Failure,Unit>> addExpense(ExpenseEntity expense);
  Future<Either<Failure,List<ExpenseEntity>>> getExpensesByMonth(int month, int year);
  Future<Either<Failure,List<BillEntity>>> getSalesByMonth(int month, int year);


}