import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    super.id,
    required super.code,
    required super.name,
    required super.category,
    required super.season,
    required super.wholesalePrice,
    required super.sellingPrice,
    required super.stockQuantity,
  });
  
  // Convert SQLite into dart model to deal with it easily in our application.
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      code: map['code'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      season: map['season'] as String,
      wholesalePrice: (map['wholesale_price'] as num).toDouble(),
      sellingPrice: (map['selling_price'] as num).toDouble(),
      stockQuantity: map['stock_quantity'] as int,
    );
  }
  
  // Convert dart model to map which SQLite can deal with while inserting or updating.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'category': category,
      'season' : season,
      'wholesale_price': wholesalePrice,
      'selling_price': sellingPrice,
      'stock_quantity': stockQuantity,
    };
  }
  
  // Convert entity into model to help us using toMap() function while dealing with DB.
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      category: entity.category,
      season:  entity.season,
      wholesalePrice: entity.wholesalePrice,
      sellingPrice: entity.sellingPrice,
      stockQuantity: entity.stockQuantity,
    );
  }
}
