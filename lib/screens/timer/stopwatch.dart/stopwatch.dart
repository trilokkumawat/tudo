import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/components/custom_button.dart';
import 'package:todo/screens/timer/stopwatch.dart/stopwatch_controller.dart';
import 'package:todo/flutter_flow_model.dart';
import 'package:provider/provider.dart';

class StopWatchScreen extends StatelessWidget {
  const StopWatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return wrapWithModel<StopWatchController>(
      model: StopWatchController(),
      updateCallback: () => (context as Element).markNeedsBuild(),
      child: const _StopWatchScreenBody(),
    );
  }
}

class _StopWatchScreenBody extends StatefulWidget {
  const _StopWatchScreenBody({Key? key}) : super(key: key);

  @override
  State<_StopWatchScreenBody> createState() => _StopWatchScreenBodyState();
}

class _StopWatchScreenBodyState extends State<_StopWatchScreenBody> {
  late StopWatchController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = context.read<StopWatchController>();
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
                  _controller.formatTime(_controller.elapsed),
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
                  onPressed: _controller.isRunning
                      ? null
                      : () => _controller.start(_update),
                  child: const Text('Start'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _controller.isRunning
                      ? () => _controller.pause(_update)
                      : null,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _controller.elapsed > 0
                      ? () => _controller.stop(_update)
                      : null,
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Show only the last record
            if (_controller.records.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Last Record",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_controller.formatTime(_controller.elapsed)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
