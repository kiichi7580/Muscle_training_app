import 'package:flutter/material.dart';
import 'package:muscle_training_app/main_navigation.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainNavigation(uid: uid),
    );
  }
}
