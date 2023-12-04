import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view_model/timer_model/add_timer_model.dart';
import 'package:provider/provider.dart';

class AddTimerPage extends StatelessWidget {
  const AddTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddTimerModel>(
      create: (_) => AddTimerModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('タイマーを追加'),
        ),
        backgroundColor: mainColor,
        body: Center(
          child: Consumer<AddTimerModel>(
            builder: (context, model, child) {
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
                              height: 60,
                              width: 294,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: '名前',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (text) {
                                    model.timerName = text;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
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
                                      decoration: const InputDecoration(
                                        hintText: '分数を入力',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (text) {
                                        model.minute = text;
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
                                      decoration: const InputDecoration(
                                        hintText: '秒数を入力',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (text) {
                                        model.second = text;
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
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    model.startLoding();
                                    await model.addTimer();
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    print(e);
                                    final snackBar = SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(e.toString()),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } finally {
                                    model.endLoding();
                                  }
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
            },
          ),
        ),
      ),
    );
  }
}
