import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/timer/display_timer.dart';
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

                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.alarm_on),
                        title: Text(
                          '${timer.minute}' + ':' + '${timer.second}',
                          style: TextStyle(fontSize: 40),
                        ),
                        trailing: Icon(Icons.start),
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
}
