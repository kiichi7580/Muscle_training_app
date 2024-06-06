import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:muscle_training_app/domain/protein_notification.dart';
import 'package:muscle_training_app/view/profile/notification/notification_items/notification_request_permissions.dart';
import 'package:muscle_training_app/view/profile/notification/notification_items/protein_notification_content.dart';
import 'package:muscle_training_app/view/profile/notification/widgets/show_notification_permission_dialog.dart';
import 'package:muscle_training_app/view/profile/notification/protein_notification_times_preferences.dart';
import 'package:muscle_training_app/widgets/cupertino_switch_tile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationSettingPage extends ConsumerStatefulWidget {
  @override
  NotificationSettingPageState createState() => NotificationSettingPageState();
}

class NotificationSettingPageState
    extends ConsumerState<NotificationSettingPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<ProteinNotification> proteinNotificationTimes = [];

  @override
  void initState() {
    super.initState();
    loadProteinNotificationTimes().then((loadedTimes) {
      setState(() {
        proteinNotificationTimes = loadedTimes;
      });
    });
    init();
  }

  Future<void> init() async {
    try {
      await requestPermissions();
      await dailyProteinNotifications(proteinNotificationTimes);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteNotification(int index) async {
    setState(() {
      proteinNotificationTimes.removeAt(index);
    });
    await saveProteinNotificationTimes(proteinNotificationTimes);
    await flutterLocalNotificationsPlugin.cancel(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text(
          '通知設定',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: Column(
        children: [
          // buildSwitchTile(
          //   title: '連続ログイン',
          //   message: 'アプリに連続してログインすると通知が送られます。',
          //   value: false,
          //   onChanged: (bool) {},
          // ),
          buildSwitchTile(
            title: 'プロテイン',
            message: '設定された時間に通知が送られ、プロテインの飲み忘れを防ぎます。',
            value: proteinNotificationTimes.isNotEmpty,
            onChanged: (bool) async {
              await Permission.notification.request();
              final status = await Permission.notification.status;

              print('status: $status');
              if (status == PermissionStatus.permanentlyDenied) {
                final response = await showNotificationPermissionDialog(
                  context,
                );
                if (response == null || response == false) {
                  return;
                }
                await openAppSettings();

                return;
              } else if (status == PermissionStatus.granted) {
                DatePicker.showTime12hPicker(
                  context,
                  onConfirm: (dateTime) async {
                    setState(() {
                      proteinNotificationTimes.add(ProteinNotification(
                        hour: dateTime.hour,
                        minute: dateTime.minute,
                        second: 0,
                        isActive: true,
                      ));
                      saveProteinNotificationTimes(proteinNotificationTimes);
                      dailyProteinNotifications(proteinNotificationTimes);
                    });
                  },
                  onCancel: () {},
                  locale: LocaleType.jp,
                );
              }
            },
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: proteinNotificationTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                      ),
                      Text(
                        '通知${index + 1}: ${proteinNotificationTimes[index].hour}時${proteinNotificationTimes[index].minute}分',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoSwitch(
                        value: proteinNotificationTimes[index].isActive,
                        onChanged: (bool value) {
                          setState(() {
                            proteinNotificationTimes[index] =
                                ProteinNotification(
                              hour: proteinNotificationTimes[index].hour,
                              minute: proteinNotificationTimes[index].minute,
                              second: proteinNotificationTimes[index].second,
                              isActive: value,
                            );
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteNotification(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  buildSwitchTile({
    required String title,
    required String message,
    required bool value,
    required void Function(bool)? onChanged,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.04,
      width: double.infinity,
      margin: EdgeInsets.all(16),
      child: CupertinoSwitchTile(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Tooltip(
              message: message,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(10),
              verticalOffset: 20,
              preferBelow: true,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              waitDuration: const Duration(seconds: 3),
              showDuration: const Duration(seconds: 5),
              triggerMode: TooltipTriggerMode.tap,
              enableFeedback: true,
              child: Icon(
                CupertinoIcons.question_circle,
                color: Colors.grey,
                size: 24,
              ),
            ),
          ],
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  // 連続ログイン達成用通知
  // Future<void> consecutiveLoginAchievedNotification(
  //     DateTime selectedDate) async {
  //   int hour = selectedDate.hour;
  //   int minute = selectedDate.minute;
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'MM',
  //     '連続ログイン達成！',
  //     tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'MM-muscle-daily',
  //         'MM-muscle-daily',
  //         channelDescription: '連続ログイン達成おめでとうございます！\n今日も体を鍛えて、すてきな1日にしましょう！',
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }
}
