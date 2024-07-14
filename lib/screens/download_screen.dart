import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadScreen extends StatelessWidget {
  final String downloadLink;
  final String password;

  const DownloadScreen({required this.downloadLink, required this.password, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Screen'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(downloadLink),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _copyToClipboard(context, downloadLink, 'Download link'),
              child: Text('Copy Link'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Password'),
              onSubmitted: (enteredPassword) {
                if (enteredPassword == password) {
                  _openDownloadLink(context);
                } else {
                  _showErrorDialog(context, 'Incorrect Password', 'The password you entered is incorrect.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  void _openDownloadLink(BuildContext context) async {
    final Uri url = Uri.parse(downloadLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showErrorDialog(context, 'Error', 'Could not open the download link.');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
