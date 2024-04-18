import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  final String id;
  final String event;
  final String weight;
  final String set;
  final String rep;
  final int dateId;
  final DateTime time;
  final String uid;

  const Memo({
    required this.id,
    required this.event,
    required this.weight,
    required this.set,
    required this.rep,
    required this.dateId,
    required this.time,
    required this.uid,
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
      time: snapshot['time'],
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
        'time': time,
        'uid': uid,
      };
}
