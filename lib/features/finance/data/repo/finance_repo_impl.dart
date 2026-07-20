import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/finance/data/data_sources/finance_local_data_source.dart';
import 'package:point_zero/features/finance/data/models/expense_model.dart';
import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';
import 'package:point_zero/features/finance/domain/repo/finance_repo.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceLocalDataSource localDataSource;
  FinanceRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> addExpense(ExpenseEntity expense) async {
    try {
      final expenseModel = ExpenseModel.fromEntity(expense);
      await localDataSource.addExpense(expenseModel);
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpensesByMonth(
    int month,
    int year,
  ) async {
    try {
      final result = await localDataSource.getExpenseByMonth(month, year);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BillEntity>>> getSalesByMonth(
    int month,
    int year,
  ) async {
    try {
      final result = await localDataSource.getBillsByMonth(month, year);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }
}
