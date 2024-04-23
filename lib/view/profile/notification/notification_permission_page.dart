import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPermissionPage extends StatefulWidget {
  const NotificationPermissionPage({super.key});

  @override
  State<NotificationPermissionPage> createState() =>
      _NotificationPermissionPageState();
}

class _NotificationPermissionPageState
    extends State<NotificationPermissionPage> {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      await requestPermissions();
      // await scheduleDailyTenAMNotification();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: const Text(
          '通知設定',
        ),
        backgroundColor: blueColor,
      ),
      body: Center(child: Text('aaa')),
    );
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
      // final bool? grantedNotificationPermission =
      //     await androidImplementation?.requestNotificationsPermission();
      // setState(() {
      //   _notificationsEnabled = grantedNotificationPermission ?? false;
      // });
    }
  }

  // tz.TZDateTime _nextInstanceOfTenAM() {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduledDate =
  //       tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }

  // 毎日AM10時に通知する機能
  // Future<void> scheduleDailyTenAMNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'MM',
  //       '今日も自分を鍛えていきましょう',
  //       _nextInstanceOfTenAM(),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'MM-muscle-daily',
  //           'MM-muscle-daily',
  //           channelDescription: '今日も自分を鍛えていきましょう',
  //         ),
  //       ),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }
}
