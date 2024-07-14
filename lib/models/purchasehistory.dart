class PurchaseHistory {
  final String productId;
  final String date;
  final double amount;

  PurchaseHistory({
    required this.productId,
    required this.date,
    required this.amount,
  });

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      productId: json['productId'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}
