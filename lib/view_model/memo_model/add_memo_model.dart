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
    if (event == null || event == '') {
      // ignore: only_throw_errors
      throw '種目が入力されていません';
    }
    if (weight == null || weight!.isEmpty) {
      // ignore: only_throw_errors
      throw '重量が入力されていません';
    }
    if (set == null || set!.isEmpty) {
      // ignore: only_throw_errors
      throw 'セット数が入力されていません';
    }
    if (rep == null || rep!.isEmpty) {
      // ignore: only_throw_errors
      throw '回数が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('memos').doc();

    // timeのフォーマットを変更
    final format1 = DateFormat('yyyy-MM-dd');
    final now = DateTime.now();
    final time1 = format1.format(now);
    final time = time1;


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
