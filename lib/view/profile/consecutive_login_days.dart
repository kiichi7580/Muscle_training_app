// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsecutiveLoginDays extends StatefulWidget {
  @override
  _ConsecutiveLoginDaysState createState() => _ConsecutiveLoginDaysState();
}

class _ConsecutiveLoginDaysState extends State<ConsecutiveLoginDays> {
  int consecutiveLoginDays = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchConsecutiveLoginDays();
  // }

  // Future<void> fetchConsecutiveLoginDays() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();

  //     DateTime lastLogin = (userDoc.data()['lastLogin'] as Timestamp).toDate();
  //     DateTime now = DateTime.now();

  //     // 連続ログイン日数を計算
  //     if (lastLogin.year == now.year &&
  //         lastLogin.month == now.month &&
  //         lastLogin.day == now.day - 1) {
  //       setState(() {
  //         consecutiveLoginDays =
  //             (userDoc.data()!['consecutiveLoginDays'] as int) + 1;
  //       });
  //     } else {
  //       setState(() {
  //         consecutiveLoginDays = 1; // 前日以降のログインがない場合はリセットして1日目とする
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Consecutive Login Days: $consecutiveLoginDays'),
      ),
    );
  }
}
