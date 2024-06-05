import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveLoginDate(User user) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final now = DateTime.now();

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final snapshot = await transaction.get(userDoc);
    if (!snapshot.exists) {
      transaction.set(userDoc, {
        'lastLogin': now,
        'consecutiveLoginDays': 1,
      });
      return;
    }

    final data = snapshot.data()!;
    final lastLogin = (data['lastLogin'] as Timestamp).toDate();
    final consecutiveDays = data['consecutiveLoginDays'] as int;

    if (now.difference(lastLogin).inDays == 1) {
      // 前回のログインから1日後なら連続ログイン日数を更新
      transaction.update(userDoc, {
        'lastLogin': now,
        'consecutiveLoginDays': consecutiveDays + 1,
      });
    } else if (now.difference(lastLogin).inDays > 1) {
      // 前回のログインから2日以上経過しているなら連続ログイン日数をリセット
      transaction.update(userDoc, {
        'lastLogin': now,
        'consecutiveLoginDays': 1,
      });
    }
  });
}
