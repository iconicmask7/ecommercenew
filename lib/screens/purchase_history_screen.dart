import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/purchasehistory.dart';
import '../providers/user_provider.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History'),
        backgroundColor: Colors.yellow[700],
      ),
      body: FutureBuilder(
        future: userProvider.fetchPurchaseHistory().timeout(
          Duration(seconds: 2),
          onTimeout: () {
            // Return cached or default data on timeout
            return Future.value(userProvider.purchaseHistory);
          },
        ),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching purchase history.'));
          } else {
            final List<PurchaseHistory> purchaseHistory = snapshot.data as List<PurchaseHistory>;

            return purchaseHistory.isNotEmpty
                ? ListView.builder(
              itemCount: purchaseHistory.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text('Product ID: ${purchaseHistory[i].productId}'),
                subtitle: Text(
                  'Date: ${purchaseHistory[i].date}, Amount: \$${purchaseHistory[i].amount.toStringAsFixed(2)}',
                ),
              ),
            )
                : Center(child: Text('No purchase history found.'));
          }
        },
      ),
    );
  }
}


