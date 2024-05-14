import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserFollowersModel extends ChangeNotifier {
  UserFollowersModel(this.userData) {
    this.uid = userData['uid'];
  }

  Map<dynamic, dynamic> userData;
  String uid = '';
  List<Map<dynamic, dynamic>> userFollowers = [];
  List<Map<dynamic, dynamic>> get getUserFollowers => userFollowers;

  Future<List<Map<dynamic, dynamic>>> getFollowersInfo() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<dynamic> currentUserDoc =
        await usersCollection.doc(uid).get();
    List<dynamic> followerUIDs = currentUserDoc.data()?['followers'];

    List<Map<dynamic, dynamic>> followerDocs = [];
    for (String followerUID in followerUIDs) {
      DocumentSnapshot<dynamic> followerDoc =
          await usersCollection.doc(followerUID).get();
      Map<dynamic, dynamic> followerData =
          followerDoc.data() as Map<dynamic, dynamic>;
      followerDocs.add(followerData);
    }
    notifyListeners();
    this.userFollowers = followerDocs;
    return userFollowers;
  }
}
