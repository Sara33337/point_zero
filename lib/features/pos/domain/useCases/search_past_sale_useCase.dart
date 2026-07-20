import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart'; // مسار الـ Failures
import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/pos/domain/repo/exchange_rep.dart';

class SearchPastSalesUseCase {
  final ExchangeRepository repository;

  SearchPastSalesUseCase(this.repository);
  Future<Either<Failure, List<PastSaleItemEntity>>> call(String query) async {
    return await repository.searchPastSales(query);
  }
}