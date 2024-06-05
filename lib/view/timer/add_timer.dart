// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/user.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/timer_firestore_methods.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';

class AddTimerPage extends StatefulWidget {
  const AddTimerPage({super.key});

  @override
  State<AddTimerPage> createState() => _AddTimerPageState();
}

class _AddTimerPageState extends State<AddTimerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  bool _isLoading = false;

  Future<void> addTimer(
    BuildContext context,
    String uid,
    String name,
    String minute,
    String second,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await TimerFireStoreMethods().addTimer(
        uid,
        name,
        minute,
        second,
      );
      if (res == successRes) {
        res = successAdd;
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        showSnackBar(res, context);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text(
          'タイマーを追加',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () async {},
        //     child: Text(
        //       saveTx,
        //       style: TextStyle(
        //         color: blackColor,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ],
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                    width: 294,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: '名前',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 90,
                        width: 130,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _minuteController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '分数を入力',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 90,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            ':',
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        width: 130,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextField(
                            controller: _secondController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '秒数を入力',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CupertinoButton(
                      color: blueColor,
                      onPressed: () async {
                        await addTimer(
                          context,
                          user.uid,
                          _nameController.text,
                          _minuteController.text,
                          _secondController.text,
                        );
                      },
                      child: const Text(
                        '保存する',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
