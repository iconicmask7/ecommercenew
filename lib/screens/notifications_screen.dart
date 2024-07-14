import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Settings'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Email Notifications'),
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
                // TODO: Save email notifications settings to server or local storage
                _saveNotificationsSettings();
              },
            ),
            SwitchListTile(
              title: Text('Push Notifications'),
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                });
                // TODO: Save push notifications settings to server or local storage
                _saveNotificationsSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveNotificationsSettings() {
    // Replace with logic to save notifications settings to server or local storage
    // Example:
    // Save to local storage using shared preferences or secure storage
    // Save to server using API call
    // Consider using a provider or repository pattern for managing state and data persistence
    print('Saving notifications settings: Email: $_emailNotifications, Push: $_pushNotifications');
  }
}
