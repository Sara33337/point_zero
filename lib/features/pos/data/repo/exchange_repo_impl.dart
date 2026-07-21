import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/core/errors/exceptions.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/data/data_sources/exchange_local_datasource.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/pos/domain/repo/exchange_rep.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeLocalDatasource localDataSource;

  ExchangeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<PastSaleItemEntity>>> searchPastSales(
    String query,
  ) async {
    try {
      final results = await localDataSource.searchPastSales(query);
      return Right(results);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    } catch (e) {
      return Left(LocalDatabaseFailure('حدث خطأ غير متوقع أثناء البحث: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> processExchangeTransaction({
    required PastSaleItemEntity returnedItem,
    required List<CartItemModel> replacementItems,
    required double differencePaid,
  }) async {
    try {
      await localDataSource.processExchangeTransaction(
        returnedItem: returnedItem,
        replacementItems: replacementItems,
        differencePaid: differencePaid,
      );
      return const Right(unit);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    } catch (e) {
      return Left(
        LocalDatabaseFailure('حدث خطأ غير متوقع أثناء تنفيذ الاستبدال: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query,
  ) async {
    try {
      final results = await localDataSource.searchProducts(query);
      return Right(results);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    } catch (e) {
      return Left(LocalDatabaseFailure('حدث خطأ غير متوقع أثناء البحث: $e'));
    }
  }
}
