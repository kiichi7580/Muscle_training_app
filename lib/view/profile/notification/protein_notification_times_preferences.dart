import 'dart:convert';

import 'package:muscle_training_app/domain/protein_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveProteinNotificationTimes(
    List<ProteinNotification> notifications) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> notificationStrings = notifications
      .map((notification) => jsonEncode(notification.toJson()))
      .toList();
  await prefs.setStringList('protein_notification_times', notificationStrings);
}

Future<List<ProteinNotification>> loadProteinNotificationTimes() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? notificationStrings =
      prefs.getStringList('protein_notification_times');
  if (notificationStrings == null) {
    return [];
  }
  return notificationStrings
      .map((string) => ProteinNotification.fromJson(jsonDecode(string)))
      .toList();
}
