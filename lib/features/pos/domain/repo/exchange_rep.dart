import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';

abstract class ExchangeRepository{
  Future<Either<Failure, List<PastSaleItemEntity>>> searchPastSales(String query);
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);

  
  Future<Either<Failure, Unit>> processExchangeTransaction({
    required PastSaleItemEntity returnedItem,
    required List<CartItemModel> replacementItems,
    required double differencePaid,
  });
}