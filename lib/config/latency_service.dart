import 'dart:async';
import 'package:http/http.dart' as http;

class LatencyService {
  final _latencyController = StreamController<int?>.broadcast();
  Stream<int?> get latencyStream => _latencyController.stream;

  Timer? _timer;

  // The server to ping for latency checks. Use a reliable, fast server.
  static const String _testUrl = 'https://banindo.co.id';

  void start() {
    // Start the periodic latency test
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkLatency();
    });
    // Run an immediate check as well
    _checkLatency();
  }

  void stop() {
    _timer?.cancel();
    //_latencyController.close();
  }

  Future<void> _checkLatency() async {
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