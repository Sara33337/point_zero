part of 'inventory_cubit.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

final class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState{}

class InventoryLoaded extends InventoryState{
  final List<ProductEntity> products;
  final String selectedFilter;
  
  const InventoryLoaded({required this.products ,  this.selectedFilter = 'الكل'});
  @override
  List<Object> get props => [products , selectedFilter];
}

class ProductAddedSuccess extends InventoryState {}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError({required this.message});

  @override
  List<Object> get props => [message];
}
