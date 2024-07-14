import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.yellow[700],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Your Favorites'),
            onTap: () {
              // Navigate to account settings screen
              Navigator.of(context).pushNamed('/favorites');
              },
          ),
          ListTile(
            title: Text('Purschase History'),
            onTap: () {
              // Navigate to account settings screen
              Navigator.of(context).pushNamed('/purchaseHistory');
            },
          ),
          ListTile(
            title: Text('Notification Settings'),
            onTap: () {
              // Navigate to notification settings screen
              Navigator.of(context).pushNamed('/notifications');
            },
          ),
          ListTile(
            title: Text('Feedback & Support'),
            onTap: () {
              // Navigate to feedback screen
              Navigator.of(context).pushNamed('/feedback');
            },
          ),
          // Add more settings options here
        ],
      ),
    );
  }
}

