import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';
import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/pos/domain/useCases/process_exchange_useCase.dart';
import 'package:point_zero/features/pos/domain/useCases/search_past_sale_useCase.dart';
import 'package:point_zero/features/pos/domain/useCases/search_products_useCase.dart';
// ⚠️ تأكدي من مسار الـ UseCase بتاعة البحث في المنتجات العادية عندك
// import 'package:point_zero/features/products/domain/useCases/search_products_usecase.dart';

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

  // 2. دالة إضافة المنتج للسلة البديلة
  void addReplacementItem(ProductEntity product) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);

    final existingIndex = updatedList.indexWhere(
      (element) => element.product.code == product.code,
    );
    
    if (existingIndex >= 0) {
      // لو المنتج موجود أصلاً في السلة البديلة، بنزود الكمية بتاعته
      final oldItem = updatedList[existingIndex];
      updatedList[existingIndex] = CartItemModel(
        product: oldItem.product,
        quantity: oldItem.quantity + 1,
        unitPrice: oldItem.unitPrice,
      );
    } else {
      // لو منتج جديد، بنحوله لـ CartItemModel ونضيفه بكمية 1
      updatedList.add(
        CartItemModel(
          product: product,
          quantity: 1,
          unitPrice: product.sellingPrice, // تأكدي إن اسم المتغير sellingPrice أو price حسب الـ Entity بتاعتك
        )
      );
    }

    emit(
      state.copyWith(
        replacementItems: updatedList,
        // تصفير البحث عشان الشاشة ترجع فاضية وجاهزة لبحث جديد
        replacementSearchResults: [], 
      ),
    );
    _calculateTotals();
  }

  // 3. دالة حذف المنتج من السلة البديلة
  void removeReplacementItem(CartItemModel item) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);

    updatedList.removeWhere(
      (element) => element.product.code == item.product.code,
    );

    emit(state.copyWith(replacementItems: updatedList));
    _calculateTotals(); // بنعيد الحسابات عشان الفلوس تتحدث
  }



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

  void resetExchange() {
    emit(const ExchangeState()); 
  }
}
