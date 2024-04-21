import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CalendarFireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // イベントカラーを生成
  String removeWords(String input, List<String> wordsToRemove) {
    String result = input;
    wordsToRemove.forEach((word) {
      result = result.replaceAll(word, '');
    });
    print('result: $result');
    return result;
  }

  // 予定追加処理
  Future<String> addCalendar(String title, String description,
      String eventColor, DateTime date, String uid) async {
    String res = '問題が発生しました。もう一度やり直してください。';
    try {
      if (title.isNotEmpty || description.isNotEmpty || eventColor.isNotEmpty) {
        List<String> removeStringList = [
          'MaterialColor(primary value: Color(',
          ')',
        ];
        print(removeStringList);
        final eventColorCode = removeWords(eventColor, removeStringList);
        String calendarId = const Uuid().v1();
        print(eventColorCode);
        _firestore.collection('events').doc(calendarId).set({
          'id': calendarId,
          'title': title,
          'description': description,
          'date': date,
          'eventColor': eventColorCode,
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

  // 予定変更処理
  Future<String> upDateCalendar(String title, String description,
      String eventColor, String calendarId) async {
    String res = '問題が発生しました。もう一度やり直してください。';
    try {
      if (title.isNotEmpty || description.isNotEmpty || eventColor.isNotEmpty) {
        _firestore.collection('events').doc(calendarId).update({
          'id': calendarId,
          'title': title,
          'description': description,
          'eventColor': eventColor,
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

  // 予定削除機能
  Future<String> deleteCalendar(String calendarId) async {
    String res = "削除できません。もう一度やり直してください。";
    try {
      await _firestore.collection('events').doc(calendarId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
