import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/finance/domain/repo/finance_repo.dart';

class DeleteBillItemUseCase{
  final FinanceRepository repository;
  DeleteBillItemUseCase({required this.repository});

   Future<Either<Failure,Unit>> call ({required int billItemId, required int billId}) async{
    return await repository.deleteBillItem(billItemId: billItemId, billId: billId);
   }
}