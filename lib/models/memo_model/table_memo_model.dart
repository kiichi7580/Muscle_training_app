import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TableMemoModel extends ChangeNotifier {
  List<dynamic>? memos;

  void fetchTableMemo(String date) async {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('memos')
        .where('time', isEqualTo: date)
        .orderBy('dateId', descending: true)
        .snapshots();

    await _usersStream.listen((snapshot) {
      final List<dynamic> _memos = [];
      for (var i = 0; i < snapshot.docs.length; i++) {
        final document = snapshot.docs[i];
        _memos.add(document);
      }
      this.memos = _memos;
      notifyListeners();
    });
  }
}
