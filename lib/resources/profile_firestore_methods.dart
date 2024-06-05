// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/resources/storage_methods.dart';

class ProfileFireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // プロフィール変更処理
  Future<String> upDateProfile(
    String username,
    String shortTermGoals,
    String longTermGoals,
    String uid,
  ) async {
    String res = failureUpDate;
    try {
      if (username.isNotEmpty ||
          shortTermGoals.isNotEmpty ||
          longTermGoals.isNotEmpty) {
        _firestore.collection('users').doc(uid).update({
          'username': username,
          'shortTermGoals': shortTermGoals,
          'longTermGoals': longTermGoals,
        });
        res = successRes;
      } else {
        res = validationRes;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> upDateUserIcon({
    required Uint8List? file,
    required String uid,
  }) async {
    String res = failureUpDate;
    try {
      if (file != null) {
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        _firestore.collection('users').doc(uid).update({
          'photoUrl': photoUrl,
        });
        res = successRes;
      } else {
        res = '写真を選択し直してください';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<String> uploadPost(String description, Uint8List file, String uid,
  //     String username, String profImage) async {
  //   String res = "Some error occurred";
  //   try {
  //     String photoUrl =
  //         await StorageMethods().uploadImageToStorage('posts', file, true);
  //     String postId = const Uuid().v1(); // creates unique id based on time
  //     Post post = Post(
  //       description: description,
  //       uid: uid,
  //       username: username,
  //       likes: [],
  //       postId: postId,
  //       datePublished: DateTime.now(),
  //       postUrl: photoUrl,
  //       profImage: profImage,
  //     );
  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
