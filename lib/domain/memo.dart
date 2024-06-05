// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  final String? id;
  final String event;
  final String weight;
  final String set;
  final String rep;
  final int? dateId;
  final DateTime? date;
  final String? uid;

  const Memo({
    this.id,
    required this.event,
    required this.weight,
    required this.set,
    required this.rep,
    this.dateId,
    this.date,
    this.uid,
  });

  static Memo fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Memo(
      id: snapshot['id'],
      event: snapshot['event'],
      weight: snapshot['weight'],
      set: snapshot['set'],
      rep: snapshot['rep'],
      dateId: snapshot['dateId'],
      date: snapshot['date'],
      uid: snapshot['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'event': event,
        'weight': weight,
        'set': set,
        'rep': rep,
        'dateId': dateId,
        'date': date,
        'uid': uid,
      };
}
