import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/memo.dart';

class MenuModel extends ChangeNotifier {
  List<dynamic> menus = [];
  List<Memo> memoList = [];
  List<String> menuNameList = [];

  List<dynamic> get getMenus => menus;
  List<Memo> get getMemoList => memoList;
  List<String> get getMenuNameList => menuNameList;

  void setMemoList(dynamic memo) {
    this.memoList.add(memo);
    notifyListeners();
  }

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
      setMenuNameList(menus);
      notifyListeners();
    });
  }

  void setMenuNameList(List<dynamic> menus) {
    final List<String> _menuNameList = [];
    for (var menu in menus) {
      _menuNameList.add(menu['menuName']);
    }
    this.menuNameList = _menuNameList;
    notifyListeners();
  }
}
