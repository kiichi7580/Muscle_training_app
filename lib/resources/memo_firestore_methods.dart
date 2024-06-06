// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/resources/trainingDays_firestore_methods.dart';

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
  Future<String> addMemo(
    String event,
    String weight,
    String set,
    String rep,
    String uid,
    DateTime date,
  ) async {
    String res = failureAdd;
    try {
      if (event.isNotEmpty &&
          weight.isNotEmpty &&
          set.isNotEmpty &&
          rep.isNotEmpty) {
        final List<String> removeStringList = [
          '年',
          '月',
          '日',
        ];
        DateFormat format = DateFormat('yyyy年MM月dd日');
        String formattedDate = format.format(date).toString();
        final preDateId = removeWords(formattedDate, removeStringList);
        final int dateId = int.parse(preDateId);
        String memoId = const Uuid().v1();
        _firestore.collection('memos').doc(memoId).set({
          'id': memoId,
          'event': event,
          'weight': weight,
          'set': set,
          'rep': rep,
          'dateId': dateId,
          'date': date,
          'uid': uid,
        });
        print('開始');
        res = await TrainingDaysFireStoreMethods().setOrUpdateTrainingDays(
          event,
          weight,
          set,
          rep,
          uid,
          date,
        );
        print('終了');
        res = successRes;
      } else {
        res = validationRes;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // メモ変更処理
  Future<String> upDateMemo(
    String event,
    String weight,
    String set,
    String rep,
    String uid,
    DateTime date,
    String memoId,
  ) async {
    String res = failureUpDate;
    try {
      if (event.isNotEmpty &&
          weight.isNotEmpty &&
          set.isNotEmpty &&
          rep.isNotEmpty) {
        _firestore.collection('memos').doc(memoId).update({
          'id': memoId,
          'event': event,
          'weight': weight,
          'set': set,
          'rep': rep,
        });
        res = await TrainingDaysFireStoreMethods().setOrUpdateTrainingDays(
          event,
          weight,
          set,
          rep,
          uid,
          date,
        );
        res = successRes;
      } else {
        res = validationRes;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // メモ削除機能
  Future<String> deleteMemo(dynamic memo) async {
    String res = failureDelete;
    try {
      String memoId = memo['id'];
      String set = memo['set'];
      DateTime date = memo['date'];
      String uid = memo['uid'];

      await _firestore.collection('memos').doc(memoId).delete();
      res = await TrainingDaysFireStoreMethods().deleteTrainingDays(
        set,
        date,
        uid,
      );
      res = successRes;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
