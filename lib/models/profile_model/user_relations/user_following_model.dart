import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserFollowingModel extends ChangeNotifier {
  UserFollowingModel(this.userData) {
    this.uid = userData['uid'];
  }

  Map<dynamic, dynamic> userData;
  String uid = '';
  List<Map<dynamic, dynamic>> userFollowing = [];
  List<Map<dynamic, dynamic>> get getUserFollowing => userFollowing;

  Future<List<Map<dynamic, dynamic>>> getFollowingInfo() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<dynamic> currentUserDoc =
        await usersCollection.doc(uid).get();
    List<dynamic> followingUIDs = currentUserDoc.data()?['following'];

    List<Map<dynamic, dynamic>> followingDocs = [];
    for (String followingUID in followingUIDs) {
      DocumentSnapshot<dynamic> followingDoc =
          await usersCollection.doc(followingUID).get();
      Map<dynamic, dynamic> followingData =
          followingDoc.data() as Map<dynamic, dynamic>;
      followingDocs.add(followingData);
    }
    notifyListeners();
    this.userFollowing = followingDocs;
    return userFollowing;
  }
}
