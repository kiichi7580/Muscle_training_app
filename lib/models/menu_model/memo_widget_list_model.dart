// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view/menu/widgets/edit_menu_widgets.dart';

class MemoWidgetListModel extends ChangeNotifier {
  MemoWidgetListModel(this.menu) {
    this.menuId = menu['id'];
  }

  dynamic menu;
  String menuId = '';
  List<Memo> memoList = [];
  List<Widget> memoWidgetList = [];

  bool _checked = false;
  bool _isLoding = false;
  bool get getChecked => _checked;
  bool get getLoding => _isLoding;
  List<Memo> get getMemoList => memoList;

  void startLoding() {
    _isLoding = true;
    notifyListeners();
  }

  void endLoding() {
    _isLoding = false;
    notifyListeners();
  }

  void fetchEditMemoList(context) async {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('menus')
        .doc(menuId)
        .collection('memos')
        .snapshots();

    await _usersStream.listen((snapshot) {
      final List<dynamic> _memoList = [];
      final List<Widget> _memoWidgetList = [];
      for (var i = 0; i < snapshot.docs.length; i++) {
        final document = snapshot.docs[i];
        _memoList.add(document);
        _memoWidgetList.add(EditMenuWidget(
          context,
          _memoList[i].data(),
        ));
      }
      this.memoWidgetList = _memoWidgetList;
      notifyListeners();
    });
  }
}
