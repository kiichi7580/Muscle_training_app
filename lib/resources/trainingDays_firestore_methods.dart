import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:uuid/uuid.dart';

class TrainingDaysFireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // String型のトレーニング日をDateTime型に変換する処理
  DateTime convertDateTime(String dateString) {
    // 年月日を分割
    List<String> parts = dateString.split("年");

    int year = int.parse(parts[0]); // 年
    int month = int.parse(parts[1].split("月")[0]); // 月
    int day = int.parse(parts[1].split("月")[1].split("日")[0]); // 日

// DateTimeオブジェクトを作成
    DateTime trainingDay = DateTime(year, month, day);

    print(trainingDay);
    return trainingDay;
  }

  Future<String?> checkDocumentWithtrainingDayProperty(
      String uid, DateTime trainingDay) async {
    final collectionRef =
        _firestore.collection('users').doc(uid).collection('trainingDays');
    final querySnapshot =
        await collectionRef.where('trainingDay', isEqualTo: trainingDay).get();

    String? applicableTrainingDayId;
    if (querySnapshot.docs.isNotEmpty) {
      applicableTrainingDayId = querySnapshot.docs[0].id;
      print('applicableTrainingDayId: $applicableTrainingDayId');
    } else {
      applicableTrainingDayId = null;
    }
    return applicableTrainingDayId;
  }

  Future<int> getTotalSetsBeforeSumming(
    String uid,
    DateTime trainingDay,
    String? applicableTrainingDayId,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('trainingDays')
        .doc(applicableTrainingDayId);
    final docSnapshot = await docRef.get();
    int preTotalSets = 0;
    // 'totalSets'フィールドの値を取得して返す
    if (docSnapshot.exists) {
      preTotalSets = docSnapshot.data()!['totalSets'];
      return preTotalSets;
    } else {
      // ドキュメントが存在しない場合や'totalSets'フィールドが存在しない場合は、0を返す
      return preTotalSets;
    }
  }

  int getAfTotalSets(int addSet, int preTotalSets) {
    int afTotalSets = 0;
    afTotalSets = addSet + preTotalSets;
    return afTotalSets;
  }

  int convertAmountOfTrainingValue(int afTotalSets) {
    int amountOfTraining = 0;
    if (0 < afTotalSets && afTotalSets < 9) {
      amountOfTraining = 1;
    } else if (afTotalSets < 18) {
      amountOfTraining = 2;
    } else if (afTotalSets < 27) {
      amountOfTraining = 3;
    } else if (afTotalSets < 36) {
      amountOfTraining = 4;
    }

    return amountOfTraining;
  }

  // トレーニングした日の情報をuserコレクションに追加・更新
  Future<String> setOrUpdateTrainingDays(
    String event,
    String weight,
    String set,
    String rep,
    String uid,
    String time,
  ) async {
    String res = failureAdd;
    try {
      int numberOfSet = int.parse(set);
      print('numberOfSet: $numberOfSet');
      final trainingDay = convertDateTime(time);
      print('trainingDay: $trainingDay');
      final applicableTrainingDayId =
          await checkDocumentWithtrainingDayProperty(uid, trainingDay);
      final int preTotalSets = await getTotalSetsBeforeSumming(
        uid,
        trainingDay,
        applicableTrainingDayId,
      );
      final afTotalSets = getAfTotalSets(numberOfSet, preTotalSets);
      final amountOfTraining = convertAmountOfTrainingValue(afTotalSets);
      print('amountOfTraining: $amountOfTraining');
      bool a = applicableTrainingDayId != null;
      print('applicableTrainingDayId != null: ${a}');
      // ドキュメントが存在するかどうかをチェック
      if (applicableTrainingDayId != null) {
        // 既存のドキュメントがある場合、更新
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('trainingDays')
            .doc(applicableTrainingDayId)
            .update({
          'totalSets': FieldValue.increment(numberOfSet),
          'amountOfTraining': amountOfTraining,
          'trainingDay': trainingDay,
        });
      } else {
        // ドキュメントが存在しない場合、新規追加
        String trainingDayId = const Uuid().v1();
        print('trainingDayId: $trainingDayId');
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('trainingDays')
            .doc(trainingDayId)
            .set({
          'id': trainingDayId,
          'totalSets': numberOfSet,
          'amountOfTraining': amountOfTraining,
          'trainingDay': trainingDay,
        });
        print('終了3');
        res = successRes;
      }
      print('終了2');
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// トレーニングした日の情報を削除
  Future<String> deleteTrainingDays(
    String set,
    String time,
    String uid,
  ) async {
    String res = failureDelete;
    try {
      int numberOfSet = int.parse(set);
      print('numberOfSet: $numberOfSet');
      final trainingDay = convertDateTime(time);
      print('trainingDay: $trainingDay');
      final applicableTrainingDayId =
          await checkDocumentWithtrainingDayProperty(uid, trainingDay);
      final int preTotalSets = await getTotalSetsBeforeSumming(
        uid,
        trainingDay,
        applicableTrainingDayId,
      );
      final afTotalSets = getAfTotalSets(-numberOfSet, preTotalSets);
      final amountOfTraining = convertAmountOfTrainingValue(afTotalSets);
      print('amountOfTraining: $amountOfTraining');

      if (afTotalSets == 0) {
        try {
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('trainingDays')
              .doc(applicableTrainingDayId)
              .delete();
          res = successRes;
        } catch (err) {
          res = err.toString();
        }
      } else {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('trainingDays')
            .doc(applicableTrainingDayId)
            .update({
          'totalSets': FieldValue.increment(-numberOfSet),
          'amountOfTraining': amountOfTraining,
          'trainingDay': trainingDay,
        });
      }
      res = successRes;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
