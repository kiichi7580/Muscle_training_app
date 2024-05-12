import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_notifier.g.dart';

@riverpod
class AuthStateNotifier extends _$AuthStateNotifier {
  @override
  Stream<User?> build() {
    // ユーザーの状態変更を監視
    return FirebaseAuth.instance.authStateChanges();
  }
}
