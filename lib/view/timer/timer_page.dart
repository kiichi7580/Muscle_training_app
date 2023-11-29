import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/timer/display_timer.dart';
import 'package:muscle_training_app/view/timer/edit_timer.dart';
import 'dart:async';
import 'package:muscle_training_app/view_model/timer_model/timer_model.dart';
import 'package:muscle_training_app/domain/timer.dart';

import 'package:muscle_training_app/view/timer/add_timer.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  // int? _second;
  Timer? _timers;
  bool _isRunning = false;
  int? second;

  final _audio = AudioPlayer();

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
                final List<MyTimer>? myTimers = model.myTimers;

                if (myTimers == null) {
                  return CircularProgressIndicator();
                }

                final List<Widget> widgets = myTimers.map((timer) {
                  if (timer.second.length == 1) {
                    timer.second = '0' + timer.second;
                  }

                  return Slidable(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.alarm_on),
                          title: Text(
                            '${timer.minute}' + ':' + '${timer.second}',
                            style: TextStyle(fontSize: 40),
                          ),
                          trailing: SizedBox(
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayTimerPage(
                                      maxSeconds: timer.totalSecond,
                                      seconds: timer.totalSecond),
                                ));
                          },
                        ),
                      ),
                    ),
                    endActionPane: ActionPane(
                  motion: ScrollMotion(),
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
                            content: Text('$timerを編集しました'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        model.fetchMyTimer();
                      },
                      backgroundColor: Colors.black45,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: '編集',
                    ),
                    SlidableAction(
                      onPressed: (BuildContext context) async {
                        //削除しますか？って聞いて、はいだったら削除
                        await showConfirmDialog(context, timer, model);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: '削除',
                    ),
                  ],
                ),
                  );
                }).toList();
                return ListView(
                  children: widgets,
                );
              },
            ),
          ),
          floatingActionButton:
              Consumer<MyTimerModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                //画面遷移
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTimerPage(),
                    fullscreenDialog: true,
                  ),
                );

                if (added != null && added) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('タイマーを追加しました'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                model.fetchMyTimer();
              },
              tooltip: 'タイマーを追加する',
              child: Icon(Icons.add),
            );
          })),
    );
  }
  Future showConfirmDialog(
    BuildContext context,
    MyTimer timer,
    MyTimerModel model,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("削除の確認"),
            content: Text("本当に削除しますか？"),
            actions: [
              TextButton(
                  child: Text("いいえ"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                child: Text("はい"),
                onPressed: () async {
                  //modelで削除
                  await model.delete(timer);
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('削除しました'),
                  );
                  model.fetchMyTimer();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ],
          );
        });
  }
}
