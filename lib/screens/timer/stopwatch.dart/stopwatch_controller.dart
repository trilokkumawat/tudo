import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/flutter_flow_model.dart';

class StopWatchController extends FlutterFlowModel {
  Timer? _timer;
  int _elapsed = 0; // in seconds
  bool _isRunning = false;
  final List<String> _records = [];

  int get elapsed => _elapsed;
  bool get isRunning => _isRunning;
  List<String> get records => List.unmodifiable(_records);

  void start(VoidCallback onUpdate) {
    if (_isRunning) return;
    addRecord("Start");
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsed++;
      onUpdate();
    });
    onUpdate();
  }

  void pause(VoidCallback onUpdate) {
    if (!_isRunning) return;
    addRecord("Pause");
    _timer?.cancel();
    _isRunning = false;
    onUpdate();
  }

  void stop(VoidCallback onUpdate) {
    if (_elapsed > 0) {
      addRecord("Stop");
    }
    _timer?.cancel();
    _isRunning = false;
    _elapsed = 0;
    onUpdate();
  }

  void addRecord(String action) {
    _records.add(formatTime(_elapsed));
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    // No call to super.dispose() because FlutterFlowModel defines dispose as abstract
  }

  @override
  void initState(BuildContext context) {
    // No-op for now
  }
}
