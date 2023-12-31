import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'myapp.dart';
import 'view/login/login_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              return const Myapp();
            }
            // User が null である、つまり未サインインのサインイン画面へ
            return const LoginPage();
          },
        ),
      );
}
