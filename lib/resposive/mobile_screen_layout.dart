import 'package:flutter/material.dart';
import 'package:muscle_training_app/main_navigation.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainNavigation(),
    );
  }
}