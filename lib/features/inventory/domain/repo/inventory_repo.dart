import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';

abstract class InventoryRepository {
  Future<Either<Failure , Unit>> addProduct (ProductEntity product);
  Future<Either<Failure,List<ProductEntity>>> getProducts();
  Future<Either<Failure, bool>> checkCodeExists(String code);
  Future<Either<Failure, Unit>> deleteProduct(String code);
  Future<Either<Failure, Unit>> updateProduct(ProductEntity product);
}