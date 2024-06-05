// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class Timer {
  final String id;
  final String uid;
  final String timerName;
  final int totalSeconds;
  final String minute;
  final String second;
  final DateTime createAt;

  const Timer({
    required this.id,
    required this.uid,
    required this.timerName,
    required this.totalSeconds,
    required this.minute,
    required this.second,
    required this.createAt,
  });

  static Timer fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Timer(
      id: snapshot['id'],
      uid: snapshot['uid'],
      timerName: snapshot['timerName'],
      totalSeconds: snapshot['totalSeconds'],
      minute: snapshot['minute'],
      second: snapshot['second'],
      createAt: snapshot['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'timerName': timerName,
        'totalSeconds': totalSeconds,
        'minute': minute,
        'second': second,
        'createAt': createAt,
      };
}
