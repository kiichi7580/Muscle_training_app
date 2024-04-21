import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MemoFireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // dateId生成
  String removeWords(String input, List<String> wordsToRemove) {
    String result = input;
    wordsToRemove.forEach((word) {
      result = result.replaceAll(word, '');
    });
    return result;
  }

  // メモ追加処理
  Future<String> addMemo(String event, String weight, String set, String rep,
      String uid, String time) async {
    String res = '問題が発生しました。もう一度やり直してください。';
    try {
      if (event.isNotEmpty ||
          weight.isNotEmpty ||
          set.isNotEmpty ||
          rep.isNotEmpty ||
          time.isNotEmpty) {

        final List<String> removeStringList = [
          '年',
          '月',
          '日',
        ];
        final preDateId = removeWords(time, removeStringList);
        final int dateId = int.parse(preDateId);
        String memoId = const Uuid().v1();
        _firestore.collection('memos').doc(memoId).set({
          'id': memoId,
          'event': event,
          'weight': weight,
          'set': set,
          'rep': rep,
          'dateId': dateId,
          'time': time,
          'uid': uid,
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

  // メモ変更処理
  Future<String> upDateMemo(String event, String weight, String set, String rep,
      String memoId) async {
    String res = '問題が発生しました。もう一度やり直してください。';
    try {
      if (event.isNotEmpty ||
          weight.isNotEmpty ||
          set.isNotEmpty ||
          rep.isNotEmpty) {

        _firestore.collection('memos').doc(memoId).update({
          'id': memoId,
          'event': event,
          'weight': weight,
          'set': set,
          'rep': rep,
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


  // メモ削除機能
  Future<String> deleteMemo(String memoId) async {
    String res = "削除できません。もう一度やり直してください。";
    try {
      await _firestore.collection('memos').doc(memoId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
