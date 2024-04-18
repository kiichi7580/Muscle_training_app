import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar {
  final String title;
  final String? description;
  late DateTime date;
  final String eventColor;
  final String id;
  final String uid;
  Calendar({
    required this.title,
    this.description,
    required this.date,
    required this.eventColor,
    required this.id,
    required this.uid,
  });

  factory Calendar.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    SnapshotOptions? options,
  ]) {
    // final FirebaseAuth _auth = FirebaseAuth.instance;

    final data = snapshot.data()!;

    final preDate = data['date'] as Timestamp;

    final date = preDate.toDate();

    return Calendar(
      date: date,
      title: data['title'].toString(),
      description: data['description'].toString(),
      eventColor: data['eventColor'].toString(),
      id: data['id'].toString(),
      uid: data['uid'].toString(),
    );
  }

  Map<String, Object?> toFirestore() {
    // final FirebaseAuth _auth = FirebaseAuth.instance;

    return {
      'date': Timestamp.fromDate(date).toDate(),
      'title': title,
      'description': description,
      'eventColor': eventColor,
      // 'uid': _auth.currentUser!.uid,
    };
  }
}
