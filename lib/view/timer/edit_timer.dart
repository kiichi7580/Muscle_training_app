import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/models/timer_model/edit_timer_model.dart';
import 'package:provider/provider.dart';
import '../../domain/timer.dart';

class EditTimerPage extends StatelessWidget {
  const EditTimerPage(this.timer, {super.key});
  final MyTimer timer;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTimerModel>(
      create: (_) => EditTimerModel(timer),
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: const Text(
            'タイマーを編集',
            style: TextStyle(
              color: blackColor,
            ),
          ),
          backgroundColor: blueColor,
        ),
        body: Center(
          child: Consumer<EditTimerModel>(
            builder: (context, model, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 90,
                            width: 294,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: model.timerNameController,
                                decoration: const InputDecoration(
                                  labelText: '名前',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (text) {
                                  model
                                    ..timerName = text
                                    ..setTimerName(text);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
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
                                    keyboardType: TextInputType.number,
                                    controller: model.minuteController,
                                    decoration: const InputDecoration(
                                      labelText: '分数を入力',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (text) {
                                      model
                                        ..minute = text
                                        ..setMinute(text);
                                    },
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
                                    keyboardType: TextInputType.number,
                                    controller: model.secondController,
                                    decoration: const InputDecoration(
                                      labelText: '秒数を入力',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (text) {
                                      model
                                        ..second = text
                                        ..setSecond(text);
                                    },
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
                              onPressed: model.isUpdated()
                                  ? () async {
                                      //処理の追加
                                      try {
                                        await model.update();
                                        Navigator.of(context).pop();
                                      } catch (e) {
                                        print(e);
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(e.toString()),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  : null,
                              child: const Text(
                                '変更する',
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
