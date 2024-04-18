import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final Timestamp createAt;

  const User({
    required this.email,
    required this.uid,
    required this.createAt,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = (snap.data() as Map<String, dynamic>);

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      createAt: snapshot['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'createAt': createAt,
      };
}
