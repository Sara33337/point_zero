import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart'; // مسار الـ Failures
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/pos/domain/repo/exchange_rep.dart';

class SearchProductsUsecase {
  final ExchangeRepository repository;

  SearchProductsUsecase(this.repository);
  Future<Either<Failure, List<ProductEntity>>> call(String query) async {
    return await repository.searchProducts(query);
  }
}