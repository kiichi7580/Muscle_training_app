import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMemoModel extends ChangeNotifier {
  String? event;
  String? weight;
  String? set;
  String? rep;
  String? time;
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
    if (time == null || time!.isEmpty) {
      // ignore: only_throw_errors
      throw '時間が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('memos').doc();

    // dateId生成
    String removeWords(String input, List<String> wordsToRemove) {
      String result = input;
      wordsToRemove.forEach((word) {
        result = result.replaceAll(word, '');
      });
      return result;
    }

    final List<String> removeStringList = [
      '年',
      '月',
      '日',
    ];

    final preDateId = removeWords(time!, removeStringList);
    final int dateId = int.parse(preDateId);

    // firestoreに追加
    await doc.set({
      'event': event,
      'weight': weight,
      'set': set,
      'rep': rep,
      'time': time,
      'dateId': dateId,
    });
  }
}
