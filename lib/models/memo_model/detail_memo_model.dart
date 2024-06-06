// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:muscle_training_app/domain/memo.dart';

class DetailMemoModel extends ChangeNotifier {
  List<Memo> memos = [];
  List<Memo> _cachedMemos = [];

  DateFormat format = DateFormat('yyyy年MM月dd日');
  final List<String> removeStringList = [
    '年',
    '月',
    '日',
  ];

  String removeWords(String input, List<String> wordsToRemove) {
    String result = input;
    wordsToRemove.forEach((word) {
      result = result.replaceAll(word, '');
    });
    return result;
  }

  int dateToDateId(String date) {
    final preDateId = removeWords(date, removeStringList);
    final int dateId = int.parse(preDateId);
    notifyListeners();
    return dateId;
  }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('memos')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('date', descending: false)
      .snapshots();

  Future<void> fetchTableMemo(int dateId) async {
    // キャッシュが存在する場合はキャッシュを使用する
    if (_cachedMemos.isNotEmpty) {
      memos = _cachedMemos.where((memo) => memo.dateId == dateId).toList();
      notifyListeners();
      return;
    }

    // キャッシュが存在しない場合のみデータを読み込む
    await _usersStream.first.then((snapshot) {
      for (var document in snapshot.docs) {
        final _memo = Memo(
          event: document['event'],
          weight: document['weight'],
          rep: document['rep'],
          set: document['set'],
          id: document['id'],
          dateId: document['dateId'],
          date: document['date'].toDate(),
          uid: document['uid'],
        );
        _cachedMemos.add(_memo);
      }
    });

    memos = _cachedMemos.where((memo) => memo.dateId == dateId).toList();
    notifyListeners();
  }

  List<Memo> snapshotToMemoList({
    required AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
    required int dateId,
  }) {
    List<Memo> memos = snapshot.data!.docs.map((doc) {
      return Memo(
        id: doc['id'],
        event: doc['event'],
        weight: doc['weight'],
        rep: doc['rep'],
        set: doc['set'],
        dateId: doc['dateId'],
        date: doc['date'].toDate(),
        uid: doc['uid'],
      );
    }).toList();

    memos = memos.where((memo) => memo.dateId == dateId).toList();
    return memos;
  }
}
