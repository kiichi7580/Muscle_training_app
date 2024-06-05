import 'package:cloud_firestore/cloud_firestore.dart';

class ProteinNotification {
  final int hour;
  final int minute;
  final int second;
  final bool isActive;

  const ProteinNotification({
    required this.hour,
    required this.minute,
    required this.second,
    required this.isActive,
  });

  static ProteinNotification fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ProteinNotification(
      hour: snapshot['hour'],
      minute: snapshot['minute'],
      second: snapshot['second'],
      isActive: snapshot['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
        'second': second,
        'isActive': isActive,
      };

  ProteinNotification.fromJson(Map<String, dynamic> json)
      : hour = json['hour'],
        minute = json['minute'],
        second = json['second'],
        isActive = json['isActive'];
}
