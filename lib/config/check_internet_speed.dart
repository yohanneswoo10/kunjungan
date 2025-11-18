import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class InternetSpeed {
  //static const String _testUrl = 'https://www.google.com';
  static const String _testUrl = 'https://banindo.co.id';
  final _latencyController = StreamController<int?>.broadcast();
  Stream<int?> get latencyStream => _latencyController.stream;

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> canPingServer(String serverUrl) async {
    try {
      final response = await http.get(Uri.parse(serverUrl)).timeout(const Duration(seconds: 5)); // Set a timeout
      return response.statusCode == 200; // Or other success codes
    } catch (e) {
      print('Error pinging server: $e');
      return false;
    }
  }

  Future<bool> checkServerStatus(String serverUrl) async {
    if (await hasInternetConnection()) {
      return await canPingServer(serverUrl);
    } else {
      return false; // No internet connection
    }
  }

  Future<String> measureLatency() async {
    String _latency = "Measuring...";
    final url = Uri.parse('https://banindo.co.id'); // Replace with your server URL
    try {
      final startTime = DateTime.now().microsecondsSinceEpoch;
      final response = await http.get(url);
      final endTime = DateTime.now().microsecondsSinceEpoch;

      if (response.statusCode == 200) {
        final latencyMs = (endTime - startTime) / 1000;
          _latency = "${latencyMs.toStringAsFixed(2)} ms";
      } else {
          _latency = "Error: ${response.statusCode}";
      }
      return _latency;
    } catch (e) {
        _latency = "Error: $e";
        return _latency;
    }
  }

  Future<void> checkLatency() async {
    try {
      final startTime = DateTime.now();
      await http.get(Uri.parse(_testUrl));
      final endTime = DateTime.now();
      final latency = endTime.difference(startTime).inMilliseconds;
      _latencyController.sink.add(latency);
    } catch (e) {
      // If the request fails, add `null` to the stream to indicate an issue
      _latencyController.sink.add(null);
    }
  }
}
