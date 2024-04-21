// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:muscle_training_app/domain/memo.dart';

// class TableMemoModel extends ChangeNotifier {
//   List<Memo>? memos;

//   void fetchTableMemo(String date) {
//     final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
//         .collection('memos')
//         .where('time', isEqualTo: date)
//         .orderBy('dateId', descending: true)
//         .snapshots();

//     _usersStream.listen((QuerySnapshot snapshot) {
//       final List<Memo> memos = snapshot.docs.map((DocumentSnapshot document) {
//         Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//         final String id = document.id;
//         final dynamic time = data['time'] as dynamic;
//         final String event = data['event'].toString();
//         final int dateId = data['dateId'] as int;
//         final String weight = data['weight'].toString();
//         final String set = data['set'].toString();
//         final String rep = data['rep'].toString();
//         final String uid = data['uid'].toString();
//         return Memo(id, dateId, time, event, weight, set, rep, uid);
//       }).toList();

//       this.memos = memos;
//       notifyListeners();
//     });
//   }

//   Future<void> delete(Memo memo) {
//     return FirebaseFirestore.instance.collection('memos').doc(memo.id).delete();
//   }
// }
