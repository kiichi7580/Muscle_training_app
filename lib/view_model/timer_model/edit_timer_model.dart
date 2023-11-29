import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/timer.dart';

class EditTimerModel extends ChangeNotifier {
  final MyTimer timer;
  EditTimerModel(this.timer) {
    minuteController.text = timer.minute;
    secondController.text = timer.second;
  }

  final minuteController = TextEditingController();
  final secondController = TextEditingController();

  String minute = "";
  String second = "";
  int? totalSecond;

  void setMinute(String minute) {
    this.minute = minute;
    notifyListeners();
  }

  void setSecond(String second) {
    this.second = second;
    notifyListeners();
  }

  bool isUpdated() {
    return minute != null || second != null;
  }

  Future update() async {
    this.minute = minuteController.text;
    this.second = secondController.text;

    final int totalSecond = int.parse(minute!) * 60 + int.parse(second!);

    // firestoreに追加
    await FirebaseFirestore.instance
        .collection('myTimers')
        .doc(timer.id)
        .update({
      'minute': minute,
      'second': second,
      'totalSecond': totalSecond,
    });
  }
}
