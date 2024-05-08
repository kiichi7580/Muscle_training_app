import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      if (e.code == invalid_email) {
        res = invalid_email_message;
      }
      if (e.code == email_already_in_use) {
        res = email_already_in_use_message;
      }
      if (e.code == operation_not_allowed) {
        res = operation_not_allowed_message;
      }
      if (e.code == weak_password) {
        res = weak_password_message;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Googleサインイン
  Future<String> signInWithGoogleAccount() async {
    String res = successLogin;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? userCred = userCredential.user;

      if (userCred != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          userModel.User user = userModel.User(
            email: userCred.email!,
            uid: userCred.uid,
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

          await _firestore.collection('users').doc(userCred.uid).set(
                user.toJson(),
              );
        }
        res = successRes;
      }
    } on FirebaseException catch (e) {
      if (e.code == invalid_email) {
        res = invalid_email_message;
      }
      if (e.code == email_already_in_use) {
        res = email_already_in_use_message;
      }
      if (e.code == operation_not_allowed) {
        res = operation_not_allowed_message;
      }
      if (e.code == weak_password) {
        res = weak_password_message;
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
      if (e.code == invalid_email) {
        res = invalid_email_message;
      }
      if (e.code == email_already_in_use) {
        res = email_already_in_use_message;
      }
      if (e.code == operation_not_allowed) {
        res = operation_not_allowed_message;
      }
      if (e.code == weak_password) {
        res = weak_password_message;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
