import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/inventory/domain/repo/inventory_repo.dart';

class DeleteProductUseCase {
  final InventoryRepository repository;
  DeleteProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String code) async {
    return await repository.deleteProduct(code);
  }
}