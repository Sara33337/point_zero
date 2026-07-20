import 'package:equatable/equatable.dart';
import 'package:point_zero/features/pos/domain/entities/cart_item_entity.dart';

class BillEntity extends Equatable {
  final int? id;
  final List<CartItemEntity> items;
  final double totalAmount;
  final DateTime createdAt;
  const BillEntity({
     this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
  });
  @override
 
  List<Object?> get props => [id , items , totalAmount , createdAt];
}
