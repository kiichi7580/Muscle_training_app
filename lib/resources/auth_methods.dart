import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/user.dart' as userModel;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ユーザー詳細データ取得
  Future<userModel.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return userModel.User.fromSnap(documentSnapshot);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
  }) async {
    String res = failureSignUp;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);

        userModel.User user = userModel.User(
          email: email,
          uid: cred.user!.uid,
          username: 'unknown',
          photoUrl: defaultPhotoUrlString,
          shortTermGoals: '',
          longTermGoals: '',
          createAt: DateTime.now(),
          lastLogin: DateTime.now(),
          consecutiveLoginDays: 1,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        res = successRes;
      } else {
        res = validationRes;
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

  // ログイン
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = failureLogin;

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = successRes;
      } else {
        res = validationRes;
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
