import 'dart:async';

class DownloadService {
  Future<Map<String, String>> generateDownloadLink(String productId) async {
    await Future.delayed(Duration(seconds: 2));
    return {
      'downloadLink': 'http://example.com/download/$productId',
      'password': 'random-password',
    };
  }
}