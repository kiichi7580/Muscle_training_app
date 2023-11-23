import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view/memo/table_memo.dart';


class TableMemoModel extends ChangeNotifier {

  List<Memo>? memos;

  void fetchTableMemo(String date) {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('memos')
      .where('time', isEqualTo: date)
      .snapshots();
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<Memo> memos = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String id = document.id;
        final dynamic time = data['time'] as dynamic;
        final String event = data['event'] as String;
        final String weight = data['weight'] as String;
        final String set = data['set'] as String;
        final String rep = data['rep'] as String;
        return Memo(id, time, event, weight, set, rep);
      }).toList();

      this.memos = memos;
      notifyListeners();
    });
  }

  Future delete(Memo memo) {
    return FirebaseFirestore.instance.collection('memos').doc(memo.id).delete();
  }
}
