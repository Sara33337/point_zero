part of 'pos_cubit.dart';

enum PosStatus { initial, loading, loaded, checkoutSuccess, error }

class PosState extends Equatable {
  final PosStatus status;
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;
  final List<CartItemEntity> cartItems;
  final List<CartItemEntity> returnItems;
  final bool isExchangeMode;
  final String error;

  const PosState({
    this.status = PosStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.cartItems = const [],
    this.returnItems = const[],
    this.isExchangeMode = false,
    this.error = "",
  });

  double get totalAmount {
    return cartItems.fold(0, (total, item) => total + item.subtotal);
  }

  PosState copyWith({
    PosStatus? status,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    List<CartItemEntity>? cartItems,
    List<CartItemEntity>? returnItems,
    bool? isExchangeMode,
    String? error,
  }) {
    return PosState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      cartItems: cartItems ?? this.cartItems,
      returnItems: returnItems ?? this.returnItems,
      isExchangeMode: isExchangeMode ?? this.isExchangeMode,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
    status,
    allProducts,
    filteredProducts,
    cartItems,
    error,
  ];
}


