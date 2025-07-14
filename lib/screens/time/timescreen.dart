import 'package:flutter/material.dart';
import 'package:todo/screens/time/countdown/countdown.dart';
import 'package:todo/screens/time/interval/interval.dart';
import 'package:todo/screens/time/stopwatch.dart/stopwatch.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text("Timer"), centerTitle: false),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, color: Color(0xFF12272F)),
                      SizedBox(height: 4),
                      Text(
                        "Stopwatch",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF12272F),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_bottom, color: Color(0xFF12272F)),
                      SizedBox(height: 4),
                      Text(
                        "Countdown",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF12272F),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.repeat, color: Color(0xFF12272F)),
                      SizedBox(height: 4),
                      Text(
                        "Intervals",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF12272F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StopWatchScreen(),
                  CountDownScreen(),
                  IntervalScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
