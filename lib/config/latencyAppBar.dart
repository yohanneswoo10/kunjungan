import 'package:flutter/material.dart';
import 'latency_service.dart';

class LatencyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const LatencyAppBar({super.key, required this.title});
  final String title;
  @override
  State<LatencyAppBar> createState() => _LatencyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _LatencyAppBarState extends State<LatencyAppBar> {
  final LatencyService  _latencyService = LatencyService ();

  @override
  void initState() {
    super.initState();
    _latencyService.start();
  }

  @override
  void dispose() {
    _latencyService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //title: const Text('My App'),
      title: Text(widget.title),
      backgroundColor: Colors.yellow,
      actions: [
        StreamBuilder<int?>(
          stream: _latencyService.latencyStream,
          builder: (context, snapshot) {
            final latency = snapshot.data;
            if (latency == null) {
              // Show an indicator when there's no connection
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.signal_wifi_off, color: Colors.red),
              );
            }

            // Customize the display based on latency value
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Tooltip(
                message: 'Latency: ${latency}ms',
                child: Text('${latency}ms',
                  style: TextStyle(
                    color: _getLatencyColor(latency),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // Perform search action
            print('Refresh button pressed');
          },
        ),
      ],
    );
  }

  Color _getLatencyColor(int latency) {
    if (latency < 100) {
      return Colors.green;
    } else if (latency < 300) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}