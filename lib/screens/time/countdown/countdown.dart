import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/utils/methodhelper.dart';
import 'package:audioplayers/audioplayers.dart';

class CountDownScreen extends StatefulWidget {
  const CountDownScreen({super.key});

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  int _hours = 0;
  int _minutes = 1;
  int _seconds = 0;
  int _remaining = 60;
  Timer? _timer;
  bool _isRunning = false;
  bool _hasStarted = false;
  int _totalSeconds = 60; // default
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _startPauseResume() {
    if (_remaining == 0) {
      safeSetState(this, () {
        _remaining = _hours * 3600 + _minutes * 60 + _seconds;
        _totalSeconds = _remaining;
        _isRunning = false;
        _hasStarted = false;
      });
      return;
    }
    if (_isRunning) {
      _timer?.cancel();
      safeSetState(this, () => _isRunning = false);
    } else {
      safeSetState(this, () {
        _isRunning = true;
        _hasStarted = true;
        if (!_hasStarted ||
            _remaining == _hours * 3600 + _minutes * 60 + _seconds) {
          _totalSeconds = _remaining;
        }
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_remaining > 0) {
          safeSetState(this, () {
            _remaining--;
          });
        } else {
          _timer?.cancel();
          safeSetState(this, () {
            _isRunning = false;
            _hasStarted = false;
            _hours = 0;
            _minutes = 0;
            _seconds = 0;
            _remaining = 0;
          });
          // Play sound when countdown ends
          await _audioPlayer.play(AssetSource('audio/countdown.mp3'));
        }
      });
    }
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String buttonText;
    if (_remaining == 0) {
      buttonText = "Start";
    } else if (_isRunning) {
      buttonText = "Pause";
    } else {
      buttonText = _hasStarted ? "Resume" : "Start";
    }

    final showPickers = !_hasStarted || _remaining == 0;

    return Scaffold(
      body: Column(
        spacing: 10,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showPickers) ...[
            SizedBox(height: 10),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Hours',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Minutes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Seconds',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hours picker
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 44,
                      diameterRatio: 1.2,
                      perspective: 0.005,
                      physics: const FixedExtentScrollPhysics(),
                      controller: FixedExtentScrollController(
                        initialItem: _hours,
                      ),
                      onSelectedItemChanged: (val) {
                        safeSetState(this, () {
                          _hours = val;
                          if (!_hasStarted) {
                            _remaining =
                                _hours * 3600 + _minutes * 60 + _seconds;
                          }
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) => Center(
                          child: Text(
                            '$index',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        childCount: 24,
                      ),
                    ),
                  ),
                  // Minutes picker
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 44,
                      diameterRatio: 1.2,
                      perspective: 0.005,
                      physics: const FixedExtentScrollPhysics(),
                      controller: FixedExtentScrollController(
                        initialItem: _minutes,
                      ),
                      onSelectedItemChanged: (val) {
                        safeSetState(this, () {
                          _minutes = val;
                          if (!_hasStarted) {
                            _remaining =
                                _hours * 3600 + _minutes * 60 + _seconds;
                          }
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) => Center(
                          child: Text(
                            '$index',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        childCount: 60,
                      ),
                    ),
                  ),
                  // Seconds picker
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 44,
                      diameterRatio: 1.2,
                      perspective: 0.005,
                      physics: const FixedExtentScrollPhysics(),
                      controller: FixedExtentScrollController(
                        initialItem: _seconds,
                      ),
                      onSelectedItemChanged: (val) {
                        safeSetState(this, () {
                          _seconds = val;
                          if (!_hasStarted) {
                            _remaining =
                                _hours * 3600 + _minutes * 60 + _seconds;
                          }
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) => Center(
                          child: Text(
                            '$index',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        childCount: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Only show Start button if a non-zero countdown is set
            if (_hours + _minutes + _seconds > 0 && !_hasStarted)
              ElevatedButton(
                onPressed: _startPauseResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF12272F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ] else ...[
            // Show the currently set countdown as a list below the pickers
            SizedBox(height: 10),
            if (!_hasStarted && (_hours + _minutes + _seconds > 0))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Set: '
                      '${_hours.toString().padLeft(2, '0')}:'
                      '${_minutes.toString().padLeft(2, '0')}:'
                      '${_seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            // Circular countdown display
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: _hasStarted && _totalSeconds > 0
                        ? _remaining / _totalSeconds
                        : 1.0,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF12272F),
                    ),
                  ),
                ),
                Text(
                  _formatTime(_remaining),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Pause/Resume/Stop buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startPauseResume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF12272F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _timer?.cancel();
                    safeSetState(this, () {
                      _isRunning = false;
                      _hasStarted = false;
                      _hours = 0;
                      _minutes = 0;
                      _seconds = 0;
                      _remaining = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Stop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
