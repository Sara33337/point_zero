import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class BillModel extends BillEntity {
  const BillModel({
    super.id,
    required super.items,
    required super.totalAmount,
    required super.createdAt,
  });

  factory BillModel.fromEntity(BillEntity billEntity) {
    return BillModel(
      id: billEntity.id,
      items: billEntity.items,
      totalAmount: billEntity.totalAmount,
      createdAt: billEntity.createdAt,
    );
  }

  // بنحفظ البيانات الأساسية بس في جدول الـ bills
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}