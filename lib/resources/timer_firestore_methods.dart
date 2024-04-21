import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TimerFireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // タイマー追加処理
  Future<String> addTimer(String uid, String timerName, String minute,
      String second) async {
    String res = '問題が発生しました。もう一度やり直してください。';
    try {
      if (timerName.isNotEmpty ||
          minute.isNotEmpty ||
          second.isNotEmpty) {
        
        final int totalSeconds = (int.parse(minute) * 60) + int.parse(second);

        if (second.length == 1) {
          second = '0${second}';
        }

        String timerId = const Uuid().v1();
        _firestore.collection('timers').doc(timerId).set({
          'id': timerId,
          'timerName': timerName,
          'totalSeconds': totalSeconds,
          'minute': minute,
          'second': second,
          'createAt': DateTime.now(),
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

  // タイマー変更処理
  Future<String> upDateTimer(String timerName, String minute,
      String second, String timerId) async {
    String res = '問題が発生しました。もう一度やり直してください。';
    try {
      if (timerName.isNotEmpty ||
          minute.isNotEmpty ||
          second.isNotEmpty) {
        
        final int totalSeconds = (int.parse(minute) * 60) + int.parse(second);

        if (second.length == 1) {
          second = '0${second}';
        }

        _firestore.collection('timers').doc(timerId).update({
          'id': timerId,
          'timerName': timerName,
          'totalSeconds': totalSeconds,
          'minute': minute,
          'second': second,
          'createAt': DateTime.now(),
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

  // タイマー削除機能
  Future<String> deleteTimer(String timerId) async {
    String res = "削除できません。もう一度やり直してください。";
    try {
      await _firestore.collection('timers').doc(timerId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
