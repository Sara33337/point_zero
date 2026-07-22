import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/exceptions.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/inventory/data/data_source/inventory_local_data_source.dart';
import 'package:point_zero/features/inventory/data/models/product_model.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/inventory/domain/repo/inventory_repo.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;
  InventoryRepositoryImpl({required this.localDataSource});
  @override
  Future<Either<Failure, Unit>> addProduct(ProductEntity product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      await localDataSource.addProduct(productModel);
      return const Right(unit);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    } catch (e) {
      return Left(LocalDatabaseFailure('حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final result = await localDataSource.getProduct();
      return Right(result);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    } catch (e) {
      return Left(LocalDatabaseFailure('حدث خطأ غير متوقع: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkCodeExists(String code) async {
    try {
      final exists = await localDataSource.checkCodeExists(code);
      return Right(exists);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String code) async {
    try {
      await localDataSource.deleteProduct(code);
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure('حدث خطأ أثناء الحذف: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(ProductEntity product) async {
    try {
      final productModel = ProductModel.fromEntity(product);
      await localDataSource.updateProduct(productModel);
      return const Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure('حدث خطأ أثناء التعديل: $e'));
    }
  }
}
