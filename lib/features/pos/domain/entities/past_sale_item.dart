class PastSaleItemEntity {
  final int billId;
  final String productCode;
  final String productName;
  final double unitPrice;
  final int quantity;
  final DateTime createdAt;

  const PastSaleItemEntity({
    required this.billId,
    required this.productCode,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.createdAt,
  });
}