import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
      ),
      body: const Center(
          child: Text('タイマー', style: TextStyle(fontSize: 32.0))),
    );
  }
}