import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoding = false;

  Future<void> login() async {
    if (email.isEmpty) {
      // ignore: only_throw_errors
      throw 'emailが入力されていません';
    }
    if (password.isEmpty) {
      // ignore: only_throw_errors
      throw 'パスワールドが入力されていません';
    }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = result.user?.uid;
  }
}
