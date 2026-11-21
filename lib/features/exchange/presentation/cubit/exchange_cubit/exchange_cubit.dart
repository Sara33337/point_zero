import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_zero/features/exchange/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/exchange/domain/use_cases/process_exchange_useCase.dart';
import 'package:point_zero/features/exchange/domain/use_cases/search_past_sale_useCase.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/domain/useCases/search_products_useCase.dart';

import 'exchange_state.dart';

class ExchangeCubit extends Cubit<ExchangeState> {
  final SearchPastSalesUseCase searchPastSalesUseCase;
  final ProcessExchangeUseCase processExchangeUseCase;
  final SearchProductsUsecase searchProductsUsecase;

  ExchangeCubit({
    required this.searchPastSalesUseCase,
    required this.processExchangeUseCase,
    required this.searchProductsUsecase,
  }) : super(const ExchangeState());

  // البحث في المبيعات السابقة (برقم الفاتورة أو الكود أو الاسم)
  Future<void> searchPastBills(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(
        state.copyWith(
          isSearching: false,
          searchResults: [],
          clearError: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isSearching: true, clearError: true));
    final result = await searchPastSalesUseCase(trimmed);
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
        emit(
          state.copyWith(
            isSearching: false,
            searchResults: data,
            clearError: true,
          ),
        );
      },
    );
  }

  // اختيار منتج مرتجع
  void selectReturnedItem(PastSaleItemEntity item) {
    emit(
      state.copyWith(
        returnedItem: item,
        billId: item.billId,
        returnQuantity: 1,
        maxReturnQuantity: item.quantity,
        searchResults: [],
        replacementSearchResults: [],
        clearError: true,
      ),
    );
    _calculateTotals();
  }

  // إلغاء اختيار المنتج المرتجع للبحث عن غيره
  void clearReturnedItem() {
    emit(
      state.copyWith(
        clearReturnedItem: true,
        searchResults: [],
        clearError: true,
      ),
    );
    _calculateTotals();
  }

  // تعديل كمية المنتج المرتجع
  void updateReturnQuantity(int qty, int maxQty) {
    if (qty > 0 && qty <= maxQty) {
      emit(state.copyWith(returnQuantity: qty, clearError: true));
      _calculateTotals();
    }
  }

  // البحث عن منتجات بديلة
  Future<void> searchReplacementProducts(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(
        state.copyWith(
          isSearchingReplacement: false,
          replacementSearchResults: [],
          clearError: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isSearchingReplacement: true, clearError: true));
    final result = await searchProductsUsecase(trimmed);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSearchingReplacement: false,
            replacementSearchResults: [],
            errorMessage: failure.message,
          ),
        );
      },
      (products) {
        emit(
          state.copyWith(
            isSearchingReplacement: false,
            replacementSearchResults: products,
            clearError: true,
          ),
        );
      },
    );
  }

  // إضافة منتج بديل للسلة مع التحقق من المخزون وعدم مسح الخطأ فوراً
  void addReplacementItem(ProductEntity product) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);
    final existingIndex = updatedList.indexWhere(
      (element) => element.product.code == product.code,
    );

    if (existingIndex >= 0) {
      final oldItem = updatedList[existingIndex];
      final nextQty = oldItem.quantity + 1;
      if (nextQty <= product.stockQuantity) {
        updatedList[existingIndex] = CartItemModel(
          product: oldItem.product,
          quantity: nextQty,
          unitPrice: oldItem.unitPrice,
        );
      } else {
        emit(
          state.copyWith(
            errorMessage:
                'الحد الأقصى المتاح في المخزن (${product.stockQuantity})',
          ),
        );
        return;
      }
    } else {
      if (product.stockQuantity > 0) {
        updatedList.add(
          CartItemModel(
            product: product,
            quantity: 1,
            unitPrice: product.sellingPrice,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: 'هذا المنتج نافذ من المخزن',
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        replacementItems: updatedList,
        replacementSearchResults: [],
        clearError: true,
      ),
    );
    _calculateTotals();
  }

  // تعديل كمية عنصر موجود في السلة البديلة
  void updateReplacementQuantity(CartItemModel item, int newQty) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);
    final index = updatedList.indexWhere(
      (element) => element.product.code == item.product.code,
    );
    if (index < 0) return;

    if (newQty <= 0) {
      updatedList.removeAt(index);
    } else if (newQty <= item.product.stockQuantity) {
      updatedList[index] = CartItemModel(
        product: item.product,
        quantity: newQty,
        unitPrice: item.unitPrice,
      );
    } else {
      emit(
        state.copyWith(
          errorMessage:
              'الكمية المطلوبة تتجاوز رصيد المخزن (${item.product.stockQuantity})',
        ),
      );
      return;
    }

    emit(state.copyWith(replacementItems: updatedList, clearError: true));
    _calculateTotals();
  }

  // حذف منتج بديل من السلة
  void removeReplacementItem(CartItemModel item) {
    final updatedList = List<CartItemModel>.from(state.replacementItems);
    updatedList.removeWhere(
      (element) => element.product.code == item.product.code,
    );
    emit(state.copyWith(replacementItems: updatedList, clearError: true));
    _calculateTotals();
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

    final double diff = replacementTot - credit;
    final double pays = diff > 0 ? diff : 0.0;

    emit(
      state.copyWith(
        returnCredit: credit,
        replacementTotal: replacementTot,
        customerPays: pays,
      ),
    );
  }

  // تنفيذ عملية الاستبدال
  Future<void> submitExchange() async {
    if (state.status == ExchangeStatus.loading) return;
    if (state.returnedItem == null || state.replacementItems.isEmpty) {
      emit(
        state.copyWith(
          status: ExchangeStatus.error,
          errorMessage: 'يرجى اختيار منتج مرتجع ومنتج بديل واحد على الأقل',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ExchangeStatus.loading, clearError: true));

    final itemWithCorrectQuantity = state.returnedItem!.copyWith(
      quantity: state.returnQuantity,
    );

    final params = ProcessExchangeParams(
      returnedItem: itemWithCorrectQuantity,
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
        emit(
          state.copyWith(
            status: ExchangeStatus.success,
            clearError: true,
          ),
        );
      },
    );
  }

  void updateReplacementPrice(CartItemModel item, double newPrice) {
  if (newPrice < 0) return;

  final updatedList = List<CartItemModel>.from(state.replacementItems);
  final index = updatedList.indexWhere(
    (element) => element.product.code == item.product.code,
  );
  if (index < 0) return;

  updatedList[index] = CartItemModel(
    product: item.product,
    quantity: item.quantity,
    unitPrice: newPrice,
  );

  emit(state.copyWith(replacementItems: updatedList, clearError: true));
  _calculateTotals();
}

  void resetExchange() {
    emit(const ExchangeState());
  }
}