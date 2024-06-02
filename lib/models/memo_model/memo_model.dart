import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemoModel extends ChangeNotifier {
  List<dynamic>? memos;

  DateFormat format = DateFormat('yyyy年MM月dd日');

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('memos')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('dateId', descending: true)
      .snapshots();

  Future<void> fetchMemo() async {
    await _usersStream.listen(
      (snapshot) {
        final List<dynamic> memos = [];
        for (var i = 0; i < snapshot.docs.length; i++) {
          final document = snapshot.docs[i];
          final dynamic date = document['date'].toDate() as dynamic;
          final String formattedDate = format.format(date).toString();
          if (i == 0) {
            memos.add(formattedDate);
          } else if (!memos.contains(formattedDate)) {
            memos.add(formattedDate);
          } else {}
        }

        this.memos = memos;
        notifyListeners();
      },
    );
  }
}
