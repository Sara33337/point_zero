import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/pos/domain/useCases/process_exchange_useCase.dart';
import 'package:point_zero/features/pos/domain/useCases/search_past_sale_useCase.dart';
// ⚠️ تأكدي من مسار الـ UseCase بتاعة البحث في المنتجات العادية عندك
// import 'package:point_zero/features/products/domain/useCases/search_products_usecase.dart';

import 'exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  final SearchPastSalesUseCase searchPastSalesUseCase;
  final ProcessExchangeUseCase processExchangeUseCase;

  ExchangeCubit({
    required this.searchPastSalesUseCase,
    required this.processExchangeUseCase,
    // required this.searchProductsUseCase,
  }) : super(const ExchangeState());


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

  void selectReturnedItem(PastSaleItemEntity item) {
    emit(
      state.copyWith(returnedItem: item, returnQuantity: 1, searchResults: []),
    );
    _calculateTotals();
  }

  void updateReturnQuantity(int qty, int maxQty) {
    if (qty > 0 && qty <= maxQty) {
      emit(state.copyWith(returnQuantity: qty));
      _calculateTotals();
    }
  }

  void setSearchingReplacement(bool isSearching) {
    emit(state.copyWith(isSearchingReplacement: isSearching));
  }

  void removeReplacementItem(CartItemModel item) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);

    updatedList.removeWhere(
      (element) => element.product.code == item.product.code,
    );

    emit(state.copyWith(replacementItems: updatedList));
    _calculateTotals(); // بنعيد الحسابات عشان الفلوس تتحدث
  }

  // 2. إضافة المنتج للسلة بعد اختياره من نتائج البحث
  void addReplacementItem(CartItemModel item) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);

    final existingIndex = updatedList.indexWhere(
      (element) => element.product.code == item.product.code,
    );
    if (existingIndex >= 0) {
      final oldItem = updatedList[existingIndex];
      updatedList[existingIndex] = CartItemModel(
        product: oldItem.product,
        quantity: oldItem.quantity + 1,
        unitPrice: oldItem.unitPrice,
      );
    } else {
      updatedList.add(item);
    }

    emit(
      state.copyWith(
        replacementItems: updatedList,
        isSearchingReplacement:
            false, // 👈 تصفير لستة البحث عشان الشاشة ترجع تعرض السلة
      ),
    );
    _calculateTotals();
  }

  // ==========================================
  // القسم الثالث: الحسابات وتأكيد العملية
  // ==========================================

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

    final params = ProcessExchangeParams(
      returnedItem: state.returnedItem!,
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
