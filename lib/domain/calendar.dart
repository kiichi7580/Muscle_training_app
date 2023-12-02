import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar {
  final String title;
  final String? description;
  late DateTime date;
  final String id;
  Calendar({
    required this.title,
    this.description,
    required this.date,
    required this.id,
  });

  factory Calendar.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options,]) {
    final data = snapshot.data()!;

    final preDate = data['date'] as Timestamp;

    final date = preDate.toDate();

    return Calendar(
      date: date,
      title: data['title'] as String,
      description: data['description'] as String,
      id: snapshot.id,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'date': Timestamp.fromDate(date).toDate(),
      'title': title,
      'description': description,
    };
  }
}
