import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/inventory/domain/useCases/get_products_usecase.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';
import 'package:point_zero/features/pos/domain/entities/cart_item_entity.dart';
import 'package:point_zero/features/pos/domain/useCases/checkout_useCase.dart';

part 'pos_state.dart';

class PosCubit extends Cubit<PosState> {
  final GetProductsUsecase getProductsUseCase;
  final CheckoutUseCase checkoutUseCase;
  PosCubit({required this.checkoutUseCase, required this.getProductsUseCase})
    : super(PosState());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: PosStatus.loading));

    final result = await getProductsUseCase();

    result.fold(
      (failure) =>
          emit(state.copyWith(status: PosStatus.error, error: failure.message)),
      (products) => emit(
        state.copyWith(
          status: PosStatus.loaded,
          allProducts: products,
          filteredProducts: products, // في البداية بنعرض كل المنتجات
        ),
      ),
    );
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredProducts: state.allProducts));
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = state.allProducts.where((product) {
      return product.code.toLowerCase().contains(lowerQuery) ||
          product.name.toLowerCase().contains(lowerQuery);
    }).toList();

    emit(state.copyWith(filteredProducts: filtered));
  }

  // 3. إضافة منتج للسلة (أو تزويد كميته لو موجود)
 void addToCart(ProductEntity product) {
    final List<CartItemEntity> updatedCart = List.from(state.cartItems);

    final existingIndex = updatedCart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      final existingItem = updatedCart[existingIndex];
      if (existingItem.quantity < product.stockQuantity) {
        updatedCart[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
      } else {
        emit(
          state.copyWith(
            status: PosStatus.loaded,
            error: 'الكمية المتبقية في المخزن (${product.stockQuantity}) فقط',
          ),
        );
        return;
      }
    } else {
      if (product.stockQuantity > 0) {
        updatedCart.add(
          CartItemEntity(
            product: product,
            quantity: 1,
            unitPrice: product.sellingPrice,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: PosStatus.loaded,
            error: 'المنتج "${product.name}" خلص من المخزون',
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        cartItems: updatedCart,
        status: PosStatus.loaded,
        error: '',
      ),
    );
  }

  // 4. تقليل الكمية أو حذف المنتج من السلة
  void decrementQuantity(ProductEntity product) {
    final List<CartItemEntity> updatedCart = List.from(state.cartItems);
    final existingIndex = updatedCart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      final existingItem = updatedCart[existingIndex];
      if (existingItem.quantity > 1) {
        updatedCart[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
      } else {
        // لو الكمية 1 وقللناها، نمسحه من السلة خالص
        updatedCart.removeAt(existingIndex);
      }
      emit(state.copyWith(cartItems: updatedCart, status: PosStatus.loaded));
    }
  }

  // 5. تعديل سعر البيع يدوياً (عشان لو الكاشير هيعمل خصم)
  void updateUnitPrice(ProductEntity product, double newPrice) {
    final List<CartItemEntity> updatedCart = List.from(state.cartItems);
    final existingIndex = updatedCart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
        unitPrice: newPrice,
      );
      emit(state.copyWith(cartItems: updatedCart, status: PosStatus.loaded));
    }
  }

  // 6. مسح السلة بالكامل
  void clearCart() {
    emit(state.copyWith(cartItems: const [], status: PosStatus.loaded));
  }

  /// 7. إتمام الدفع (Checkout) - ترجع رقم الفاتورة الحقيقي أو -1 عند الفشل
  Future<int> checkout() async {
    if (state.cartItems.isEmpty) return -1;
    emit(state.copyWith(status: PosStatus.loading));

    final billToSave = BillEntity(
      items: List.from(state.cartItems),
      totalAmount: state.totalAmount,
      createdAt: DateTime.now(),
      isExchange: false,
    );

    final result = await checkoutUseCase(billToSave);

    return result.fold(
      (failure) {
        emit(state.copyWith(status: PosStatus.error, error: failure.message));
        return -1;
      },
      (createdBillId) async {
        emit(
          state.copyWith(
            status: PosStatus.checkoutSuccess,
            cartItems: const [],
          ),
        );
        await loadProducts();
        return createdBillId;
      },
    );
  }

  void toggleExchangeMode(){
    emit(state.copyWith(
      isExchangeMode: !state.isExchangeMode,
      cartItems: [],
      returnItems: [],
    ));
  }
}
