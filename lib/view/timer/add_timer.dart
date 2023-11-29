import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view_model/timer_model/add_timer_model.dart';
import 'package:provider/provider.dart';

class AddTimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddTimerModel>(
        create: (_) => AddTimerModel(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('タイマーを追加'),
            ),
            backgroundColor: mainColor,
            body: Center(child:
                Consumer<AddTimerModel>(builder: (context, model, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
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
                                      decoration: const InputDecoration(
                                          hintText: '分数を入力',
                                          border: OutlineInputBorder()),
                                      onChanged: (text) {
                                        model.minute = text;
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
                                      decoration: const InputDecoration(
                                          hintText: '秒数を入力',
                                          border: OutlineInputBorder()),
                                      onChanged: (text) {
                                        model.second = text;
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
                                    child: Text(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }))));
  }
}
