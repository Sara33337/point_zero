import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';
import 'package:point_zero/features/finance/domain/repo/finance_repo.dart';

class GetMonthlyExpenseDataUseCase {
  final FinanceRepository repository;
  GetMonthlyExpenseDataUseCase({required this.repository});
  Future<Either<Failure, List<ExpenseEntity>>> call(int month, int year) async {
    return await repository.getExpensesByMonth(month, year);
  }
}
