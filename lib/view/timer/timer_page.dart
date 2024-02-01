import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/domain/timer.dart';
import 'package:muscle_training_app/view/timer/add_timer.dart';
import 'package:muscle_training_app/view/timer/display_timer.dart';
import 'package:muscle_training_app/view/timer/edit_timer.dart';
import 'package:muscle_training_app/models/timer_model/timer_model.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyTimerModel>(
      create: (_) => MyTimerModel()..fetchMyTimer(),
      child: Scaffold(
        backgroundColor: mainColor,
        body: Center(
          child: Consumer<MyTimerModel>(
            builder: (context, model, child) {
              final myTimers = model.myTimers;

              if (myTimers == null) {
                return const CircularProgressIndicator();
              }

              final List<Widget> widgets = myTimers.map((timer) {
                if (timer.second.length == 1) {
                  timer.second = '0${timer.second}';
                }

                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        onPressed: (BuildContext context) async {
                          //編集画面に遷移
                          final String? event = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTimerPage(timer),
                            ),
                          );

                          if (event != null) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('${timer.timerName}}のタイマーを編集しました'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          model.fetchMyTimer();
                        },
                        backgroundColor: blackColor,
                        foregroundColor: mainColor,
                        icon: Icons.edit,
                        label: '編集',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) async {
                          //削除しますか？って聞いて、はいだったら削除
                          await showConfirmDialog(context, timer, model);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: mainColor,
                        icon: Icons.delete,
                        label: '削除',
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.alarm_on),
                        title: Text(
                          timer.timerName,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${timer.minute}:${timer.second}',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                          ),
                        ),
                        trailing: const SizedBox(
                          height: 50,
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.edit,
                              ),
                              Icon(
                                Icons.arrow_back,
                              ),
                            ],
                          ),
                        ),
                        dense: true,
                        tileColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => DisplayTimerPage(
                                timerName: timer.timerName,
                                maxSeconds: timer.totalSecond,
                                seconds: timer.totalSecond,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }).toList();
              return ListView(
                children: widgets,
              );
            },
          ),
        ),
        floatingActionButton: Consumer<MyTimerModel>(
          builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                //画面遷移
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTimerPage(),
                    fullscreenDialog: true,
                  ),
                );

                if (added != null && added) {
                  const snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('タイマーを追加しました'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                model.fetchMyTimer();
              },
              tooltip: 'タイマーを追加する',
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> showConfirmDialog(
    BuildContext context,
    MyTimer timer,
    MyTimerModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('削除の確認'),
          content: const Text('本当に削除しますか？'),
          actions: [
            TextButton(
              child: const Text('いいえ'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('はい'),
              onPressed: () async {
                //modelで削除
                await model.delete(timer);
                Navigator.pop(context);
                const snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('削除しました'),
                );
                model.fetchMyTimer();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
