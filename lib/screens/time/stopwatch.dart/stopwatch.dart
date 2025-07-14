import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/components/custom_button.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  Timer? _timer;
  int _elapsed = 0; // in seconds
  bool _isRunning = false;
  final List<String> _records = [];

  void _start() {
    if (_isRunning) return;
    _addRecord("Start");
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed++;
      });
    });
  }

  void _pause() {
    if (!_isRunning) return;
    _addRecord("Pause");
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _stop() {
    if (_elapsed > 0) {
      _addRecord("Stop");
    }
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _elapsed = 0;
    });
  }

  void _addRecord(String action) {
    setState(() {
      _records.add(_formatTime(_elapsed));
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _formatTime(_elapsed),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _start,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isRunning ? _pause : null,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _elapsed > 0 ? _stop : null,
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Show only the last record
            if (_records.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    const Text(
                      "Last Record",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_records.last),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
