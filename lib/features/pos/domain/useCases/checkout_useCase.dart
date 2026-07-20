import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';
import 'package:point_zero/features/pos/domain/repo/pos_repo.dart';

class CheckoutUseCase {
  final PosRepository repository;

  CheckoutUseCase(this.repository);

  Future<Either<Failure, Unit>> call(BillEntity bill) async {
    if (bill.items.isEmpty) {
      return Left(ValidationFailure('لا يمكن إتمام عملية بيع وفاتورة المشتريات فارغة.'));
    }
    return await repository.checkout(bill);
  }
}