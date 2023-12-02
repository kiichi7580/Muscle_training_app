import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/memo.dart';

class MemoModel extends ChangeNotifier {
  List<dynamic>? memos;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('memos')
      // .orderBy('timeId', descending: true)
      .snapshots();

  Future<void> fetchMemo() async {
    _usersStream.listen((snapshot) {
      final List<dynamic> memos = [];
      for (var i = 0; i < snapshot.docs.length; i++) {
        // for (var document in snapshot.docs) {
        final document = snapshot.docs[i];
        final dynamic time = document['time'] as dynamic;
        if (i == 0) {
          memos.add(time);
        } else if (!memos.contains(time)) {
          memos.add(time);
        } else {}
      }

      this.memos = memos;
      notifyListeners();
    });
  }

  Future<void> delete(Memo memo) {
    return FirebaseFirestore.instance.collection('memos').doc(memo.id).delete();
  }
}
