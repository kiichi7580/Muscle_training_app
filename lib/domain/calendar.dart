// Package imports:
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

    final data = snapshot.data()!;

    final preDate = data['date'];

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

    Map<String, dynamic> toFirestore() {

    return {
      'date': date,
      'title': title,
      'description': description,
      'eventColor': eventColor,
      'id': id,
      'uid': uid,
    };
  }
}
