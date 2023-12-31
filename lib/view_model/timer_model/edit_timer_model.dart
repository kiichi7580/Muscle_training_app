import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/timer.dart';

class EditTimerModel extends ChangeNotifier {
  EditTimerModel(this.timer) {
    timerNameController.text = timer.timerName;
    minuteController.text = timer.minute;
    secondController.text = timer.second;
  }
  final MyTimer timer;

  final timerNameController = TextEditingController();
  final minuteController = TextEditingController();
  final secondController = TextEditingController();

  String timerName = '';
  String minute = '';
  String second = '';
  int? totalSecond;

  void setTimerName(String timerName) {
    this.timerName = timerName;
    notifyListeners();
  }

  void setMinute(String minute) {
    this.minute = minute;
    notifyListeners();
  }

  void setSecond(String second) {
    this.second = second;
    notifyListeners();
  }

  bool isUpdated() {
    // ignore: unnecessary_null_comparison
    return timerName != null || minute != null || second != null;
  }

  Future<void> update() async {
    this.timerName = timerNameController.text;
    this.minute = minuteController.text;
    this.second = secondController.text;

    final int totalSecond = int.parse(minute) * 60 + int.parse(second);

    // firestoreに追加
    await FirebaseFirestore.instance
        .collection('myTimers')
        .doc(timer.id)
        .update({
      'timerName': timerName,
      'minute': minute,
      'second': second,
      'totalSecond': totalSecond,
    });
  }
}
