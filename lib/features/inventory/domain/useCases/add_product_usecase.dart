import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/inventory/domain/repo/inventory_repo.dart';

class AddProductUseCase {
  final InventoryRepository repository;

  AddProductUseCase(this.repository);
  Future<Either<Failure, Unit>> call(ProductEntity product) async {
    return await repository.addProduct(product);
  }
}