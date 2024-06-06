import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:muscle_training_app/domain/protein_notification.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// プロテイン用通知 複数設定可
Future<void> dailyProteinNotifications(
    List<ProteinNotification> notificationTimes) async {
  for (int i = 0; i < notificationTimes.length; i++) {
    await dailyProteinNotification(notificationTimes[i], i);
  }
}

Future<void> dailyProteinNotification(
    ProteinNotification notificationTime, int id) async {
  if (notificationTime.isActive == false) {
    await flutterLocalNotificationsPlugin.cancel(id);
    return;
  }
  int hour = notificationTime.hour;
  int minute = notificationTime.minute;
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    'MM',
    '現在$hour:時$minute分です。\n今日もプロテインを飲んでタンパク質を摂取しましょう!',
    _nextProteinNotification(notificationTime),
    NotificationDetails(
      android: AndroidNotificationDetails(
        'MM-muscle-daily',
        'MM-muscle-daily',
        channelDescription: '現在$hour:時$minute分です。\n今日もプロテインを飲んでタンパク質を摂取しましょう!',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

tz.TZDateTime _nextProteinNotification(ProteinNotification notificationTime) {
  int hour = notificationTime.hour;
  int minute = notificationTime.minute;
  int second = notificationTime.second;
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, hour, minute, second);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
