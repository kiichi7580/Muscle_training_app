import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoginModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoding = false;

  Future<void> login() async {
    if (email.isEmpty) {
      throw 'emailが入力されていません';
    }
    if (password.isEmpty) {
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
