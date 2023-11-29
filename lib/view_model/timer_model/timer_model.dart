import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/timer.dart';

class MyTimerModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('myTimers').snapshots();

  List<MyTimer>? myTimers;

  void fetchMyTimer() {
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<MyTimer> myTimers = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        final String id = document.id;
        final int totalSecond = data['totalSecond'] as int;
        final String minute = data['minute'] as String;
        final String second = data['second'] as String;
        return MyTimer(id, totalSecond, minute, second);
      }).toList();

      this.myTimers = myTimers;
      notifyListeners();
    });
  }

  Future delete(MyTimer myTimer) {
    return FirebaseFirestore.instance.collection('myTimers').doc(myTimer.id).delete();
  }
}
