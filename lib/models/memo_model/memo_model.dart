import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MemoModel extends ChangeNotifier {
  List<dynamic>? memos;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('memos')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('dateId', descending: true)
      .snapshots();

  Future<void> fetchMemo() async {
    _usersStream.listen(
      (snapshot) {
        final List<dynamic> memos = [];
        for (var i = 0; i < snapshot.docs.length; i++) {
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
      },
    );
  }
}
