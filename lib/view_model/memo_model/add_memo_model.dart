import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMemoModel extends ChangeNotifier {
  String? event;
  String? weight;
  String? set;
  String? rep;
  bool isLoding = false;

  void startLoding() {
    isLoding = true;
    notifyListeners();
  }

  void endLoding() {
    isLoding = false;
    notifyListeners();
  }

  Future<void> addMemo() async {
    if (event == null || event == "") {
      throw '種目が入力されていません';
    }
    if (weight == null || weight!.isEmpty) {
      throw '重量が入力されていません';
    }
    if (set == null || set!.isEmpty) {
      throw 'セット数が入力されていません';
    }
    if (rep == null || rep!.isEmpty) {
      throw '回数が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('memos').doc();

    // final time = Timestamp.fromDate(DateTime.now());

    final format1 = DateFormat('yyyy-MM-dd');
    DateTime now = DateTime.now();
    final time1 = format1.format(now);
    final time = time1.toString();

    // firestoreに追加
    await doc.set({
      'event': event,
      'weight': weight,
      'set': set,
      'rep': rep,
      'time': time,
    });
  }
}
