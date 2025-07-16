import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/router/app_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo/utils/notification_helper.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestAllPermissions() async {
  await [Permission.notification].request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationHelper.initialize();

  // Request all permissions at startup
  await requestAllPermissions();

  // Request notification permissions for Android 13+ and iOS
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF12272F)),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
