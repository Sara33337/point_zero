import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/inventory/domain/useCases/add_product_usecase.dart';
import 'package:point_zero/features/inventory/domain/useCases/delete_product_useCase.dart';
import 'package:point_zero/features/inventory/domain/useCases/edit_product_useCase.dart';
import 'package:point_zero/features/inventory/domain/useCases/generate_code_useCase.dart';
import 'package:point_zero/features/inventory/domain/useCases/get_products_usecase.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final GetProductsUsecase getProductsUsecase;
  final AddProductUseCase addProductUseCase;
  final GenerateUniqueCodeUseCase generateUniqueCodeUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final UpdateProductUseCase updateProductUseCase;

  InventoryCubit({
    required this.getProductsUsecase,
    required this.addProductUseCase,
    required this.generateUniqueCodeUseCase,
    required this.deleteProductUseCase,
    required this.updateProductUseCase,
  }) : super(InventoryInitial());

  List<ProductEntity> _allProducts = [];
  String _currentSearchQuery = '';
  String _currentSeasonFilter = 'الكل';

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

  void searchProduct(String query) {
    _currentSearchQuery = query;
    _applyFilters();
  }

  void changeSeasonFilter(String season) {
    _currentSeasonFilter = season;
    _applyFilters();
  }

  void _applyFilters() {
    List<ProductEntity> filteredList = List.from(_allProducts);

    if (_currentSeasonFilter != 'الكل') {
      filteredList = filteredList.where((product) {
        return product.season == _currentSeasonFilter;
      }).toList();
    }

    if (_currentSearchQuery.isNotEmpty) {
      final lowerQuery = _currentSearchQuery.toLowerCase();
      filteredList = filteredList.where((product) {
        return product.code.toLowerCase().contains(lowerQuery) ||
            product.name.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    emit(
      InventoryLoaded(
        products: filteredList,
        selectedFilter: _currentSeasonFilter,
      ),
    );
  }

  Future<void> deleteProduct(String code) async {
    final result = await deleteProductUseCase(code);
    result.fold(
      (failure) {
        emit(InventoryError(message: failure.message));
        return null;
      },
      (_) {
        _allProducts = List<ProductEntity>.from(_allProducts);
        _allProducts.removeWhere((p) => p.code == code);
        _applyFilters();
        
      },
    );
  }

  Future<void> updateProduct(ProductEntity updatedProduct) async {
    final result = await updateProductUseCase(updatedProduct);

    result.fold(
      (failure) {
        emit(InventoryError(message: failure.message));
        return null;
      },
      (_) {
        _allProducts = List<ProductEntity>.from(_allProducts);
        final index = _allProducts.indexWhere(
          (p) => p.code == updatedProduct.code,
        );
        if (index != -1) {
          _allProducts[index] = updatedProduct;
          _applyFilters();
        }
      },
    );
  }
}
