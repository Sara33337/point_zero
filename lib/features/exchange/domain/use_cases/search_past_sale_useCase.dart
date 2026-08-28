import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/exchange/domain/entities/past_sale_item.dart'; 

import 'package:point_zero/features/exchange/domain/repo/exchange_rep.dart';

class SearchPastSalesUseCase {
  final ExchangeRepository repository;

  SearchPastSalesUseCase(this.repository);
  Future<Either<Failure, List<PastSaleItemEntity>>> call(String query) async {
    return await repository.searchPastSales(query);
  }
}