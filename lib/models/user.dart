import 'package:ecommercepart/models/purchasehistory.dart';

class User {
  final String userName;
  final String email;
  final String name;
  final List<PurchaseHistory> purchaseHistory;

  User({
    required this.userName,
    required this.email,
    required this.name,
    required this.purchaseHistory,
  });

  User copyWith({
    String? userName,
    String? email,
    String? name,
    List<PurchaseHistory>? purchaseHistory,
  }) {
    return User(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      name: name ?? this.name,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    var list = json['purchaseHistory'] as List;
    List<PurchaseHistory> purchaseHistoryList = list.map((e) => PurchaseHistory.fromJson(e)).toList();

    return User(
      userName: json['userName'],
      email: json['email'],
      name: json['name'],
      purchaseHistory: purchaseHistoryList,
    );
  }
}
