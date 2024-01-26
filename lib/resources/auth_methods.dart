import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = '何か問題が起きました。';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'email': email,
        });

        res = 'success';
      }
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'メールアドレスが有効で有効ではありません。';
      }
      if (e.code == 'email-already-in-use') {
        res = 'そのメールアドレスを持つアカウントは既に存在しています。';
      }
      if (e.code == 'operation-not-allowed') {
        res =
            'アカウントが有効ではありません。Firebase コンソールの Auth タブで、メール/パスワード アカウントを有効にしてください。';
      }
      if (e.code == 'weak-password') {
        res = 'パスワードを強化してください。';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
