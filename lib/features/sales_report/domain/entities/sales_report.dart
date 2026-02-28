class SalesReport {
  final String orderId;
  final String shopName;
  final DateTime date;
  final List<SalesItem> items;
  final double totalAmount;

  SalesReport({
    required this.orderId,
    required this.shopName,
    required this.date,
    required this.items,
    required this.totalAmount,
  });
}

class SalesItem {
  final String productName;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final double totalPrice;

  SalesItem({
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
    required this.totalPrice,
  });
}
