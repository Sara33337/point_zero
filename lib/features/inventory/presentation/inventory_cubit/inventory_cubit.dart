import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/inventory/domain/useCases/add_product_usecase.dart';
import 'package:point_zero/features/inventory/domain/useCases/generate_code_useCase.dart';
import 'package:point_zero/features/inventory/domain/useCases/get_products_usecase.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final GetProductsUsecase getProductsUsecase;
  final AddProductUseCase addProductUseCase;
  final GenerateUniqueCodeUseCase generateUniqueCodeUseCase;
  InventoryCubit({
    required this.getProductsUsecase,
    required this.addProductUseCase,
    required this.generateUniqueCodeUseCase,
  }) : super(InventoryInitial());

  List<ProductEntity> _allProducts = [];

  Future<void> loadProducts() async {
    emit(InventoryLoading());
    final result = await getProductsUsecase();
    result.fold((failure) => emit(InventoryError(message: failure.message)), (
      products,
    ) {
      _allProducts = products;
      emit(InventoryLoaded(products: _allProducts, selectedFilter: 'الكل'));
    });
  }

  Future<void> addProduct(ProductEntity product) async {
    emit(InventoryLoading());
    final result = await addProductUseCase(product);
    result.fold(
      (failure) => emit(InventoryError(message: failure.message)),
      (_) => emit(ProductAddedSuccess()),
    );
    loadProducts();
  }

  Future<String?> getNewProductCode() async {
    final result = await generateUniqueCodeUseCase();
    return result.fold(
      (failure) {
        emit(InventoryError(message: failure.message));
        return null;
      },
      (code) => code, // نعيد الكود للـ UI
    );
  }

  void changeSeasonFilter(String season) {
    List<ProductEntity> filteredList;
    if (season == 'الكل') {
      filteredList = _allProducts;
    } else {
      filteredList = _allProducts.where((p) => p.season == season).toList();
    }

    emit(InventoryLoaded(products: filteredList, selectedFilter: season));
  }
}
