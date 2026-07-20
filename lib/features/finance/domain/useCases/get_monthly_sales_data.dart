import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/finance/domain/repo/finance_repo.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class GetMonthlySalesDataUseCase {
  final FinanceRepository repository;
  GetMonthlySalesDataUseCase({required this.repository});
  Future<Either<Failure, List<BillEntity>>> call(int month, int year) async {
    return await repository.getSalesByMonth(month, year);
  }
}
