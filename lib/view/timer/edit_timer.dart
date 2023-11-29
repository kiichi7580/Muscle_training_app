import 'package:flutter/material.dart';
import 'package:muscle_training_app/view_model/memo_model/edit_memo_model.dart';
import 'package:muscle_training_app/view_model/timer_model/edit_timer_model.dart';
import 'package:muscle_training_app/view_model/timer_model/timer_model.dart';
import 'package:provider/provider.dart';
import '../../domain/timer.dart';

class EditTimerPage extends StatelessWidget {
  final MyTimer timer;
  EditTimerPage(this.timer);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTimerModel>(
      create: (_) => EditTimerModel(timer),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('タイマーを編集'),
        ),
        body: Center(
          child: Consumer<EditTimerModel>(builder: (context, model, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 90,
                              width: 130,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: model.minuteController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()),
                                  onChanged: (text) {
                                    model.minute = text;
                                    model.setMinute(text);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 90,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: model.secondController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()),
                                  onChanged: (text) {
                                    model.second = text;
                                    model.setSecond(text);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '閉じる',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              height: 50,
                              width: 120,
                              child: ElevatedButton(
                                onPressed: model.isUpdated()
                                    ? () async {
                                        //処理の追加
                                        try {
                                          await model.update();
                                          Navigator.of(context)
                                              .pop();
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
                                child: Text(
                                  '変更する',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
