import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_zero/features/exchange/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';

import 'package:point_zero/features/exchange/domain/use_cases/process_exchange_useCase.dart';
import 'package:point_zero/features/exchange/domain/use_cases/search_past_sale_useCase.dart';
import 'package:point_zero/features/pos/domain/useCases/search_products_useCase.dart';

import 'exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  final SearchPastSalesUseCase searchPastSalesUseCase;
  final ProcessExchangeUseCase processExchangeUseCase;
  final SearchProductsUsecase searchProductsUsecase;

  ExchangeCubit({
    required this.searchPastSalesUseCase,
    required this.processExchangeUseCase,
    required this.searchProductsUsecase
    // required this.searchProductsUseCase,
  }) : super(const ExchangeState());

  // serach for returned items
  Future<void> searchPastBills(String query) async {
    if (query.isEmpty) return;
    emit(state.copyWith(isSearching: true, errorMessage: null));
    final result = await searchPastSalesUseCase(query);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSearching: false,
            searchResults: [],
            errorMessage: failure.message,
          ),
        );
      },
      (data) {
        emit(state.copyWith(isSearching: false, searchResults: data));
      },
    );
  }
  
  // select returned item
  void selectReturnedItem(PastSaleItemEntity item) {
    emit(
      state.copyWith(returnedItem: item, 
      billId: item.billId,
      returnQuantity: 1, searchResults: [],
      maxReturnQuantity: item.quantity,),
    );
    _calculateTotals();
  }
  
  // change selected returned item quantity
  void updateReturnQuantity(int qty, int maxQty) {
    if (qty > 0 && qty <= maxQty) {
      emit(state.copyWith(returnQuantity: qty));
      _calculateTotals();
    }
  }
  
  // search for replacement items
  Future<void> searchReplacementProducts(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(isSearchingReplacement: false, replacementSearchResults: []));
      return;
    }

    emit(state.copyWith(isSearchingReplacement: true, errorMessage: null));

    final result = await searchProductsUsecase(query);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSearchingReplacement: false,
          replacementSearchResults: [],
          errorMessage: failure.message,
        ));
      },
      (products) {
        emit(state.copyWith(
          isSearchingReplacement: false,
          replacementSearchResults: products,
        ));
      },
    );
  }

  // add replacement item to cart
  void addReplacementItem(ProductEntity product) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);
    final existingIndex = updatedList.indexWhere((element) => element.product.code == product.code);

    if (existingIndex >= 0) {
      final oldItem = updatedList[existingIndex];
      // 👈 التحقق من المخزن هنا
      if (oldItem.quantity < product.stockQuantity) {
        updatedList[existingIndex] = CartItemModel(
          product: oldItem.product,
          quantity: oldItem.quantity + 1,
          unitPrice: oldItem.unitPrice,
        );
      } else {
        emit(state.copyWith(errorMessage: 'الكمية المطلوبة غير متوفرة في المخزن'));
        // تفريغ رسالة الخطأ فوراً عشان متثبتش
        emit(state.copyWith(errorMessage: null));
        return;
      }
    } else {
      // 👈 التحقق للمنتج الجديد
      if (product.stockQuantity > 0) {
        updatedList.add(
          CartItemModel(
            product: product,
            quantity: 1,
            unitPrice: product.sellingPrice,
          )
        );
      } else {
        emit(state.copyWith(errorMessage: 'هذا المنتج نافذ من المخزن'));
        emit(state.copyWith(errorMessage: null));
        return;
      }
    }

    emit(state.copyWith(replacementItems: updatedList, replacementSearchResults: []));
    _calculateTotals();
  }

  // reomve replacemnets from cart
  void removeReplacementItem(CartItemModel item) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);

    updatedList.removeWhere(
      (element) => element.product.code == item.product.code,
    );

    emit(state.copyWith(replacementItems: updatedList));
    _calculateTotals(); // بنعيد الحسابات عشان الفلوس تتحدث
  }


  // calcuations
  void _calculateTotals() {
    double credit = 0.0;
    if (state.returnedItem != null) {
      credit = state.returnedItem!.unitPrice * state.returnQuantity;
    }

    double replacementTot = 0.0;
    for (var item in state.replacementItems) {
      replacementTot += (item.unitPrice * item.quantity);
    }

    double diff = replacementTot - credit;
    double pays = diff > 0 ? diff : 0.0;

    emit(
      state.copyWith(
        returnCredit: credit,
        replacementTotal: replacementTot,
        customerPays: pays,
      ),
    );
  }
  
  // submit exchange
  Future<void> submitExchange() async {
    if (state.returnedItem == null || state.replacementItems.isEmpty) return;

    emit(state.copyWith(status: ExchangeStatus.loading, errorMessage: null));

    final itemWithCorrectQuantity = state.returnedItem!.copyWith(
      quantity: state.returnQuantity, 
    );

    final params = ProcessExchangeParams(
      returnedItem: itemWithCorrectQuantity, // 👈 بنبعت النسخة المتعدلة
      replacementItems: state.replacementItems,
      differencePaid: state.customerPays,
    );

    final result = await processExchangeUseCase(params);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ExchangeStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(state.copyWith(status: ExchangeStatus.success));
      },
    );
  }
  
  // reset exchange screen
  void resetExchange() {
    emit(const ExchangeState()); 
  }
}
