import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

// Add a custom enum for repeat types
enum CustomRepeatType { none, hourly, daily, weekly, monthly }

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // Add a global navigation key
  static GlobalKey<NavigatorState>? navigatorKey;

  static Future<void> initialize([BuildContext? context]) async {
    if (_initialized) return;
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
        );
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        _handleNotificationTap(response);
      },
    );
    _initialized = true;
  }

  // Handle notification tap for all app states
  static void _handleNotificationTap(NotificationResponse response) {
    // Example: Navigate to home ('/') or a specific route
    navigatorKey?.currentState?.pushNamed('/');
    // If you want to use payload:
    // final payload = response.payload;
    // navigatorKey?.currentState?.pushNamed('/task-details', arguments: payload);
  }

  // Call this from main.dart after initializing NotificationHelper
  static Future<void> handleAppLaunchFromNotification() async {
    final details = await _notificationsPlugin
        .getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      if (details!.notificationResponse != null) {
        _handleNotificationTap(details.notificationResponse!);
      }
    }
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    DateTime? scheduledDate,
    String? payload, // Add payload for navigation/data
    required String type, // 'exact' or 'interval'
    CustomRepeatType repeatType = CustomRepeatType.none,
  }) async {
    await initialize();
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Task reminders',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('alarm'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'alarm.caf',
      ),
      macOS: DarwinNotificationDetails(),
    );
    if (type == "exact" && scheduledDate != null) {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        payload: payload,
      );
    } else if (type == "interval") {
      switch (repeatType) {
        case CustomRepeatType.hourly:
          await _notificationsPlugin.periodicallyShow(
            id,
            title,
            body,
            RepeatInterval.hourly,
            notificationDetails,
            androidAllowWhileIdle: true,
            payload: payload,
          );
          break;
        case CustomRepeatType.daily:
          await _notificationsPlugin.periodicallyShow(
            id,
            title,
            body,
            RepeatInterval.daily,
            notificationDetails,
            androidAllowWhileIdle: true,
            payload: payload,
          );
          break;
        case CustomRepeatType.weekly:
          await _notificationsPlugin.periodicallyShow(
            id,
            title,
            body,
            RepeatInterval.weekly,
            notificationDetails,
            androidAllowWhileIdle: true,
            payload: payload,
          );
          break;
        case CustomRepeatType.monthly:
          // No built-in monthly, so schedule the next one manually
          if (scheduledDate != null) {
            await _notificationsPlugin.zonedSchedule(
              id,
              title,
              body,
              tz.TZDateTime.from(scheduledDate, tz.local),
              notificationDetails,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
              payload: payload,
            );
          }
          break;
        case CustomRepeatType.none:
        default:
          // Do nothing or throw
          break;
      }
    }
  }

  static Future<void> requestIOSPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static const int stopwatchNotificationId = 999;

  static Future<void> showStopwatchNotification(
    String status,
    String elapsed,
  ) async {
    await initialize();
    await _notificationsPlugin.show(
      stopwatchNotificationId,
      'Stopwatch: ' + status,
      'Elapsed: ' + elapsed,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'stopwatch_channel',
          'Stopwatch',
          channelDescription: 'Stopwatch status',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          showWhen: false,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  static Future<void> cancelStopwatchNotification() async {
    await _notificationsPlugin.cancel(stopwatchNotificationId);
  }
}
