import 'package:point_zero/features/exchange/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';


enum ExchangeStatus { initial, loading, success, error }

class ExchangeState {
  final ExchangeStatus status;
  final String? errorMessage;
  
  // returned item
  final PastSaleItemEntity? returnedItem;
  final bool isSearching;
  final List<PastSaleItemEntity> searchResults;
  final int? billId;
  final int returnQuantity;
  final int maxReturnQuantity;

  // total blocks
  final double returnCredit;
  final double customerPays;


  // replacement item
  final List<CartItemModel> replacementItems;
  final double replacementTotal;
  final bool isSearchingReplacement;
  final List<ProductEntity> replacementSearchResults;

  const ExchangeState({
    this.status = ExchangeStatus.initial,
    this.errorMessage,
    this.returnedItem,
    this.billId,
    this.returnQuantity = 1,
    this.maxReturnQuantity = 1,
    this.replacementItems = const [],
    this.returnCredit = 0.0,
    this.replacementTotal = 0.0,
    this.customerPays = 0.0,
    this.isSearching = false,
    this.searchResults = const [],
    this.isSearchingReplacement = false,
    this.replacementSearchResults = const [],
  });

  ExchangeState copyWith({
    ExchangeStatus? status,
    String? errorMessage,
    PastSaleItemEntity? returnedItem,
    BillEntity? bill,
    int? billId,
    int? returnQuantity,
    int? maxReturnQuantity,
    List<CartItemModel>? replacementItems,
    double? returnCredit,
    double? replacementTotal,
    double? customerPays,
    bool? isSearching,
    List<PastSaleItemEntity>? searchResults,
    List<ProductEntity>? replacementSearchResults,
    bool? isSearchingReplacement,
  }) {
    return ExchangeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      returnedItem: returnedItem ?? this.returnedItem,
      billId: billId ?? this.billId,
      returnQuantity: returnQuantity ?? this.returnQuantity,
      maxReturnQuantity: maxReturnQuantity ?? this.maxReturnQuantity,
      replacementItems: replacementItems ?? this.replacementItems,
      returnCredit: returnCredit ?? this.returnCredit,
      replacementTotal: replacementTotal ?? this.replacementTotal,
      customerPays: customerPays ?? this.customerPays,
      isSearching: isSearching ?? this.isSearching,
      searchResults: searchResults ?? this.searchResults,
      replacementSearchResults:
          replacementSearchResults ?? this.replacementSearchResults,
      isSearchingReplacement:
          isSearchingReplacement ?? this.isSearchingReplacement,
    );
  }
}
