import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoding = false;

  Future<void> signup() async {
    if (email.isEmpty) {
      // ignore: only_throw_errors
      throw 'emailが入力されていません';
    }
    if (password.isEmpty) {
      // ignore: only_throw_errors
      throw 'パスワールドが入力されていません';
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = auth.currentUser?.uid;

    final doc = FirebaseFirestore.instance.collection('users').doc();

    // firestoreに追加
    await doc.set({
      'email': email,
      'createAt': DateTime.now(),
      'uid': uid,
    });
  }
}
