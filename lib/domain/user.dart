import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final DateTime createAt;

  const User({
    required this.email,
    required this.uid,
    required this.createAt,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    DateTime createdAt = (snapshot['createAt'] as Timestamp).toDate();

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      createAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'createAt': createAt,
      };
}
