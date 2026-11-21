import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/finance/domain/repo/finance_repo.dart';

class UpdateBillItemUseCase{
  final FinanceRepository repository;
  UpdateBillItemUseCase({required this.repository});

   Future<Either<Failure,Unit>> call ({required int billItemId, required int billId, required int newQuantity, required double newUnitPrice}) async{
    return await repository.updateBillItem(billItemId: billItemId, billId: billId, newQuantity: newQuantity, newUnitPrice: newUnitPrice);
   }
}