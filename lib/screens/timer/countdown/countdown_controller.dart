import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:todo/flutter_flow_model.dart';

class CountdownController extends FlutterFlowModel {
  int hours = 0;
  int minutes = 1;
  int seconds = 0;
  int remaining = 60;
  Timer? _timer;
  bool isRunning = false;
  bool hasStarted = false;
  int totalSeconds = 60;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void startPauseResume(VoidCallback onUpdate) {
    if (remaining == 0) {
      hours = 0;
      minutes = 0;
      seconds = 0;
      remaining = 0;
      totalSeconds = 0;
      isRunning = false;
      hasStarted = false;
      onUpdate();
      return;
    }
    if (isRunning) {
      _timer?.cancel();
      isRunning = false;
      onUpdate();
    } else {
      isRunning = true;
      hasStarted = true;
      if (!hasStarted || remaining == hours * 3600 + minutes * 60 + seconds) {
        totalSeconds = remaining;
      }
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (remaining > 0) {
          remaining--;
          onUpdate();
        } else {
          _timer?.cancel();
          isRunning = false;
          hasStarted = false;
          hours = 0;
          minutes = 0;
          seconds = 0;
          remaining = 0;
          onUpdate();
          await _audioPlayer.play(AssetSource('audio/countdown.mp3'));
        }
      });
      onUpdate();
    }
  }

  void stop(VoidCallback onUpdate) {
    _timer?.cancel();
    isRunning = false;
    hasStarted = false;
    hours = 0;
    minutes = 0;
    seconds = 0;
    remaining = 0;
    onUpdate();
  }

  String formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
  }

  @override
  void initState(BuildContext context) {}
}
