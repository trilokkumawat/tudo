import 'package:flutter/material.dart';
import 'package:todo/utils/methodhelper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:todo/screens/time/countdown/countdown_controller.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:provider/provider.dart';

class CountDownScreen extends StatelessWidget {
  const CountDownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return wrapWithModel<CountdownController>(
      model: CountdownController(),
      updateCallback: () => (context as Element).markNeedsBuild(),
      child: const _CountDownScreenBody(),
    );
  }
}

class _CountDownScreenBody extends StatefulWidget {
  const _CountDownScreenBody({Key? key}) : super(key: key);

  @override
  State<_CountDownScreenBody> createState() => _CountDownScreenBodyState();
}

class _CountDownScreenBodyState extends State<_CountDownScreenBody> {
  late CountdownController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = context.read<CountdownController>();
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String buttonText;
    if (_controller.remaining == 0) {
      buttonText = "Start";
    } else if (_controller.isRunning) {
      buttonText = "Pause";
    } else {
      buttonText = _controller.hasStarted ? "Resume" : "Start";
    }

    final showPickers = !_controller.hasStarted || _controller.remaining == 0;

    return Scaffold(
      body: Column(
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
                        initialItem: _controller.hours,
                      ),
                      onSelectedItemChanged: (val) {
                        setState(() {
                          _controller.hours = val;
                          if (!_controller.hasStarted) {
                            _controller.remaining =
                                _controller.hours * 3600 +
                                _controller.minutes * 60 +
                                _controller.seconds;
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
                        initialItem: _controller.minutes,
                      ),
                      onSelectedItemChanged: (val) {
                        setState(() {
                          _controller.minutes = val;
                          if (!_controller.hasStarted) {
                            _controller.remaining =
                                _controller.hours * 3600 +
                                _controller.minutes * 60 +
                                _controller.seconds;
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
                        initialItem: _controller.seconds,
                      ),
                      onSelectedItemChanged: (val) {
                        setState(() {
                          _controller.seconds = val;
                          if (!_controller.hasStarted) {
                            _controller.remaining =
                                _controller.hours * 3600 +
                                _controller.minutes * 60 +
                                _controller.seconds;
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
            if (_controller.hours + _controller.minutes + _controller.seconds >
                    0 &&
                !_controller.hasStarted)
              ElevatedButton(
                onPressed: () => _controller.startPauseResume(_update),
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
            SizedBox(height: 10),
            if (!_controller.hasStarted &&
                (_controller.hours + _controller.minutes + _controller.seconds >
                    0))
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
                      '${_controller.hours.toString().padLeft(2, '0')}:'
                      '${_controller.minutes.toString().padLeft(2, '0')}:'
                      '${_controller.seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value:
                        _controller.hasStarted && _controller.totalSeconds > 0
                        ? _controller.remaining / _controller.totalSeconds
                        : 1.0,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF12272F),
                    ),
                  ),
                ),
                Text(
                  _controller.formatTime(_controller.remaining),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.startPauseResume(_update),
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
                  onPressed: () => _controller.stop(_update),
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
