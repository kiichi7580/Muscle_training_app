import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TimerModel extends ChangeNotifier {
  List<dynamic>? timers;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('timers')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  void fetchTimer() {
    _usersStream.listen((snapshot) {
      final List<dynamic> timers = [];
      for (var i = 0; i < snapshot.docs.length; i++) {
        final document = snapshot.docs[i];
        timers.add(document);
      }
      this.timers = timers;
      notifyListeners();
    });
  }
}
