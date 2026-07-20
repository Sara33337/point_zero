import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';
import 'package:point_zero/features/finance/domain/repo/finance_repo.dart';

class AddExpenseUseCase{
  final FinanceRepository repository;
  AddExpenseUseCase({required this.repository});

   Future<Either<Failure,Unit>> call (ExpenseEntity expense) async{
    return await repository.addExpense(expense);
   }
}