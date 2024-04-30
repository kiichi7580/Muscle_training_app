import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuModel extends ChangeNotifier {
  List<dynamic>? menus;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('menus')
      .snapshots();

  void fetchMenu() async {
    await _usersStream.listen((snapshot) {
      final List<dynamic> menus = [];
      for (var i = 0; i < snapshot.docs.length; i++) {
        final document = snapshot.docs[i];
        menus.add(document);
      }
      this.menus = menus;
      notifyListeners();
    });
  }
}
