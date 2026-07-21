class ProductEntity {
  final int? id; 
  final String code;
  final String name;
  final String category;
  final String season;
  final double wholesalePrice;
  final double sellingPrice;
  final int stockQuantity;

  ProductEntity({
    this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.season,
    required this.wholesalePrice,
    required this.sellingPrice,
    required this.stockQuantity,
  });

}