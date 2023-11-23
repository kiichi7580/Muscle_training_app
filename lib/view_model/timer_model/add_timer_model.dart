import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTimerModel extends ChangeNotifier {
  String? minute;
  String? second;
  int? totalSecond;

  bool isLoding = false;

  void startLoding() {
    isLoding = true;
    notifyListeners();
  }

  void endLoding() {
    isLoding = false;
    notifyListeners();
  }

  Future<void> addTimer() async {
    if (minute == null) {
      throw '分数が入力されていません';
    }
    if (minute! is int) {
      throw '数字で入力してください';
    }
    if (second == null) {
      throw '秒数が入力されていません';
    } else if (second! is int) {
      throw '数字で入力してください';
    }

    final totalSecond = int.parse(minute!) * 60 + int.parse(second!);
    

    final doc = FirebaseFirestore.instance.collection('myTimers').doc();

    // firestoreに追加
    await doc.set({
      'minute': minute,
      'second': second,
      'totalSecond': totalSecond,
    });
  }
}
