import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
// 👈 استدعينا الـ Entity هنا
import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';

enum ExchangeStatus { initial, loading, success, error }

class ExchangeState {
  final ExchangeStatus status;
  final String? errorMessage;
  
  // 👈 التعديل الأول: استخدمنا الـ Entity بدل الـ Map
  final PastSaleItemEntity? returnedItem; 
  final int returnQuantity; 
  
  final List<CartItemModel> replacementItems; 

  final double returnCredit;     
  final double replacementTotal; 
  final double customerPays;     
  final bool isSearching; 
  
  
  // 👈 التعديل التاني: نتائج البحث بقت لستة من الـ Entity
  final List<PastSaleItemEntity> searchResults;

  final bool isSearchingReplacement;
final List<ProductEntity> replacementSearchResults;

  const ExchangeState({
    this.status = ExchangeStatus.initial,
    this.errorMessage,
    this.returnedItem,
    this.returnQuantity = 1,
    this.replacementItems = const [],
    this.returnCredit = 0.0,
    this.replacementTotal = 0.0,
    this.customerPays = 0.0,
    this.isSearching = false,
    this.searchResults = const [], 
     this.isSearchingReplacement = false,
      this.replacementSearchResults = const[],
  });

  ExchangeState copyWith({
    ExchangeStatus? status,
    String? errorMessage,
    PastSaleItemEntity? returnedItem, // 👈 تعديل
    int? returnQuantity,
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
      returnQuantity: returnQuantity ?? this.returnQuantity,
      replacementItems: replacementItems ?? this.replacementItems,
      returnCredit: returnCredit ?? this.returnCredit,
      replacementTotal: replacementTotal ?? this.replacementTotal,
      customerPays: customerPays ?? this.customerPays,
      isSearching: isSearching ?? this.isSearching,
      searchResults: searchResults ?? this.searchResults,
      replacementSearchResults: replacementSearchResults ?? this.replacementSearchResults,
      isSearchingReplacement: isSearchingReplacement ?? this.isSearchingReplacement,
    );
  }
}