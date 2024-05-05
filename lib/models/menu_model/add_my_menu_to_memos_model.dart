import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/resources/memo_firestore_methods.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';

class AddMyMenuToMemosModel extends ChangeNotifier {
  AddMyMenuToMemosModel(this.menu) {
    this.menu = menu;
  }
  dynamic menu;
  bool _isLoding = false;

  int memoListLen = 0;
  List<dynamic> memoList = [];
  List<dynamic> get getMemoList => memoList;

  void readMenu(BuildContext context) async {
    try {
      var memoListSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(menu['uid'])
          .collection('menus')
          .doc(menu['id'])
          .collection('memos')
          .get();
      this.memoListLen = memoListSnap.docs.length;
      final List<dynamic> _memoList = [];
      for (var i = 0; i < memoListLen; i++) {
        DocumentSnapshot memo = memoListSnap.docs[i];
        _memoList.add(memo);
        print('memo: ${memo['event']}');
      }
      this.memoList = _memoList;
      print('memoList: $memoList');
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    notifyListeners();
  }

  void startLoding() {
    _isLoding = true;
    notifyListeners();
  }

  void endLoding() {
    _isLoding = false;
    notifyListeners();
  }

  Future<String> addMenuToMemos(String memoDate) async {
    String res = '';
    try {
      for (var memo in this.memoList) {
        res = await MemoFireStoreMethods().addMemo(
          memo['event'],
          memo['weight'],
          memo['set'],
          memo['rep'],
          menu['uid'],
          memoDate,
        );
      }
      res = successRes;
    } catch (err) {
      res = err.toString();
    }
    notifyListeners();
    return res;
  }
}
