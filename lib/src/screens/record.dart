import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ'),
      ),
      body: const Center(
          child: Text('メモ', style: TextStyle(fontSize: 32.0))),
    );
  }
}