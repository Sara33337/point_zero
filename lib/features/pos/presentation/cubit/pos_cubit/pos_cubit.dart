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

    // هل المنتج ده موجود في السلة أصلاً؟
    final existingIndex = updatedCart.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // موجود -> نزود الكمية
      final existingItem = updatedCart[existingIndex];
      if (existingItem.quantity < product.stockQuantity) {
        updatedCart[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
      } else {
        // لو الكمية المطلوبة أكبر من المخزن، ممكن نطلع Error state مؤقت
        emit(
          state.copyWith(
            status: PosStatus.error,
            error: 'الكمية غير متوفرة في المخزن',
          ),
        );
        emit(
          state.copyWith(status: PosStatus.loaded),
        ); // نرجع للحالة العادية فوراً
        return;
      }
    } else {
      // مش موجود -> نضيفه كعنصر جديد
      if (product.stockQuantity > 0) {
        updatedCart.add(
          CartItemEntity(
            product: product,
            quantity: 1,
            unitPrice: product.sellingPrice, // السعر الافتراضي
          ),
        );
      }
    }

    emit(state.copyWith(cartItems: updatedCart, status: PosStatus.loaded));
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

  // 7. إتمام الدفع (Checkout)
  Future<void> checkout() async {
    if (state.cartItems.isEmpty) return;
    emit(state.copyWith(status: PosStatus.loading));

    final bill = BillEntity(
      items: state.cartItems,
      totalAmount: state.totalAmount,
      createdAt: DateTime.now(),
      isExchange: false,
    );

    final result = await checkoutUseCase(bill);

    result.fold(
      (failure) =>
          emit(state.copyWith(status: PosStatus.error, error: failure.message)),
      (_) {
        // نجاح الفاتورة -> نفضي السلة ونحدث بضاعة المخزن
        emit(
          state.copyWith(
            status: PosStatus.checkoutSuccess,
            cartItems: const [],
          ),
        );
        loadProducts();
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
