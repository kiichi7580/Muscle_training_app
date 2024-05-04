import 'package:cloud_firestore/cloud_firestore.dart';

class trainingDays {
  final String id;
  final DateTime trainingDay;
  final int totalSets;
  final int amountOfTraining;

  const trainingDays({
    required this.id,
    required this.trainingDay,
    required this.totalSets,
    required this.amountOfTraining,
  });

  static trainingDays fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return trainingDays(
      id: snapshot['id'],
      trainingDay: snapshot['trainingDay'],
      totalSets: snapshot['totalSets'],
      amountOfTraining: snapshot['amountOfTraining'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'trainingDay': trainingDay,
        'totalSets': totalSets,
        'amountOfTraining': amountOfTraining,
      };
}
