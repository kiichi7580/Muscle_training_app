import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class ProfileFireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // プロフィール変更処理
  Future<String> upDateProfile(
    String username,
    String photoUrl,
    String description,
    String uid,
  ) async {
    String res = '問題が発生しました。もう一度やり直してください。';
    try {
      if (username.isNotEmpty ||
          photoUrl.isNotEmpty ||
          description.isNotEmpty) {
        _firestore.collection('users').doc(uid).update({
          'username': username,
          'photoUrl': photoUrl,
          'description': description,
        });
        res = 'success';
      } else {
        res = 'すべての項目を入力してください';
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
