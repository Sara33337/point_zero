import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/pos/domain/repo/exchange_rep.dart';

class ProcessExchangeParams {
  final PastSaleItemEntity returnedItem;
  final List<CartItemModel> replacementItems;
  final double differencePaid;

  ProcessExchangeParams({
    required this.returnedItem,
    required this.replacementItems,
    required this.differencePaid,
  });
}

class ProcessExchangeUseCase {
  final ExchangeRepository repository;

  ProcessExchangeUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ProcessExchangeParams params) async {
    return await repository.processExchangeTransaction(
      returnedItem: params.returnedItem,
      replacementItems: params.replacementItems,
      differencePaid: params.differencePaid,
    );
  }
}