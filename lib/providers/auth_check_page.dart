import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/providers/auth_state_notifier.dart';
import 'package:muscle_training_app/resposive/mobile_screen_layout.dart';
import 'package:muscle_training_app/resposive/resposive_layout.dart';
import 'package:muscle_training_app/resposive/web_screen_layout.dart';
import 'package:muscle_training_app/view/login/login_page.dart';

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final userAsyncValue = ref.watch(authStateNotifierProvider);
            return userAsyncValue.when(
              data: (user) {
                if (user != null) {
                  return ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                  );
                } else {
                  return LoginPage();
                }
              },
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: linkBlue,
                ),
              ),
              error: (error, stackTrace) => Text('Error: $error'),
            );
          },
        ),
      ),
    );
  }
}
