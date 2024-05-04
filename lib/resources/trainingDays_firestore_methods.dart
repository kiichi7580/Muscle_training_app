// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:muscle_training_app/constant/text_resorce.dart';
// import 'package:uuid/uuid.dart';

// class TrainingDaysFireStoreMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String> addTrainingDays(String event, String weight, String set,
//       String rep, String uid, String time) async {
//     String res = failureAdd;
//     try {
//       if (event.isNotEmpty ||
//           weight.isNotEmpty ||
//           set.isNotEmpty ||
//           rep.isNotEmpty ||
//           time.isNotEmpty) {
//         String memoId = const Uuid().v1();
//         _firestore.collection('memos').doc(memoId).set({
//           'id': memoId,
//           'event': event,
//           'weight': weight,
//           'set': set,
//           'rep': rep,
//           'time': time,
//           'uid': uid,
//         });
//         res = successRes;
//       } else {
//         res = validationRes;
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   // メモ変更処理
//   Future<String> upDateMemo(String event, String weight, String set, String rep,
//       String memoId) async {
//     String res = failureUpDate;
//     try {
//       if (event.isNotEmpty ||
//           weight.isNotEmpty ||
//           set.isNotEmpty ||
//           rep.isNotEmpty) {
//         _firestore.collection('memos').doc(memoId).update({
//           'id': memoId,
//           'event': event,
//           'weight': weight,
//           'set': set,
//           'rep': rep,
//         });
//         res = successRes;
//       } else {
//         res = validationRes;
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   // メモ削除機能
//   Future<String> deleteMemo(String memoId) async {
//     String res = failureDelete;
//     try {
//       await _firestore.collection('memos').doc(memoId).delete();
//       res = successRes;
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }
// }