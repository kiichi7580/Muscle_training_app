import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final String photoUrl;
  final String description;
  final DateTime createAt;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.description,
    required this.createAt,
    required this.followers,
    required this.following,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    DateTime createdAt = (snapshot['createAt'] as Timestamp).toDate();

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      description: snapshot['description'],
      createAt: createdAt,
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'username': username,
        'photoUrl': photoUrl,
        'description': description,
        'createAt': createAt,
        'followers': followers,
        'following': following,
      };
}
