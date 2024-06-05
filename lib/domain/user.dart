// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final String photoUrl;
  final String shortTermGoals;
  final String longTermGoals;
  final DateTime createAt;
  final DateTime lastLogin;
  final int consecutiveLoginDays;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.username,
    required this.photoUrl,
    required this.shortTermGoals,
    required this.longTermGoals,
    required this.createAt,
    required this.lastLogin,
    required this.consecutiveLoginDays,
    required this.followers,
    required this.following,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    DateTime createdAt = (snapshot['createAt'] as Timestamp).toDate();
    DateTime lastLogin = (snapshot['lastLogin'] as Timestamp).toDate();

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      shortTermGoals: snapshot['shortTermGoals'],
      longTermGoals: snapshot['longTermGoals'],
      createAt: createdAt,
      lastLogin: lastLogin,
      consecutiveLoginDays: snapshot['consecutiveLoginDays'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'username': username,
        'photoUrl': photoUrl,
        'shortTermGoals': shortTermGoals,
        'longTermGoals': longTermGoals,
        'createAt': createAt,
        'lastLogin': lastLogin,
        'consecutiveLoginDays': consecutiveLoginDays,
        'followers': followers,
        'following': following,
      };
}
