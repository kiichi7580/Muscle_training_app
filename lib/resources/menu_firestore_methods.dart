import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:uuid/uuid.dart';

class MenuFireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // メニュー追加処理
  Future<String> addMenu(String uid, String menuName, List<Memo> memos) async {
    String res = failureAdd;
    try {
      if (menuName.isNotEmpty || memos.isNotEmpty) {
        String menuId = const Uuid().v1();
        _firestore
            .collection('users')
            .doc(uid)
            .collection('menus')
            .doc(menuId)
            .set({
          'id': menuId,
          'menuName': menuName,
          'uid': uid,
        });

        for (var i = 0; i < memos.length; i++) {
          String memoId = const Uuid().v1();
          _firestore
              .collection('users')
              .doc(uid)
              .collection('menus')
              .doc(menuId)
              .collection('memos')
              .doc(memoId)
              .set({
            'id': memoId,
            'event': memos[i].event,
            'weight': memos[i].weight,
            'rep': memos[i].rep,
            'set': memos[i].set,
          });
        }
        res = successRes;
      } else {
        res = validationRes;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // メニュー変更処理
  Future<String> upDateMenu(
    String uid,
    String menuId,
    String menuName,
    List<Memo> memos,
  ) async {
    String res = failureUpDate;
    try {
      if (menuName.isNotEmpty || memos.isNotEmpty) {
        _firestore
            .collection('users')
            .doc(uid)
            .collection('menus')
            .doc(menuId)
            .update({
          'menuName': menuName,
        });
        for (var memo in memos) {
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('menus')
              .doc(menuId)
              .collection('memos')
              .doc(memo.id)
              .update({
            'event': memo.event,
            'weight': memo.weight,
            'rep': memo.rep,
            'set': memo.set,
          });
        }
        res = successRes;
      } else {
        res = validationRes;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // メニュー削除機能
  Future<String> deleteMenu(String uid, String menuId) async {
    String res = failureDelete;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('menus')
          .doc(menuId)
          .delete();

      // メニュードキュメントに紐づくメモサブコレクションを取得して削除
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('menus')
          .doc(menuId)
          .collection('memos')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      res = successRes;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
