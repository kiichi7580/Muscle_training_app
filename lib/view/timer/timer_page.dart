import 'package:flutter/material.dart';
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
          appBar: AppBar(
            title: Text('タイマー'),
          ),
          body: Center(
            child: Consumer<MyTimerModel>(builder: (context, model, child) {
              final List<MyTimer>? myTimers = model.myTimers;

              if (myTimers == null) {
                return CircularProgressIndicator();
              }

              final List<Widget> widgets = myTimers.map((timer) {
                // return Center(
                //     child: ListTile(
                //   title: Text(
                //     timer.totalSecond.toString(),
                //     style: TextStyle(fontSize: 30),
                //   ),
                // )
                // );

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            '${timer.minute}' + ':' + '${timer.second}',
                            // timer.totalSecond.toString(),
                            style: TextStyle(fontSize: 40),
                          ),
                          TextButton(
                          child: Text(
                            'タイマーを使う',
                            style: TextStyle(
                            fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayTimerPage(maxSeconds: timer.totalSecond, seconds: timer.totalSecond),
                                ));
                            },
                          ),
                        ],
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     stop(context, timer, model);
                    //   },
                    //   child: Text(
                    //     _isRunning ? 'ストップ' : 'スタート',
                    //     style: TextStyle(
                    //       color: _isRunning ? Colors.red : Colors.green,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     resetTimer(context, timer, model);
                    //   },
                    //   child: Text(
                    //     'リセット',
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              }).toList();
              return ListView(
                children: widgets,
              );
            }),
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

  // void stop(
  //   BuildContext context,
  //   MyTimer timer,
  //   MyTimerModel model,
  // ) {
  //   if (!_isRunning) {
  //     _timers = Timer.periodic(const Duration(seconds: 1), (timers) {
  //       setState(() {
  //         timer.totalSecond--;
  //       });

  //       if (timer.totalSecond == 0) {
  //         _audio.play(AssetSource("Clock-Alarm02-4(Button).mp3"));
  //         _isRunning = false;
  //       }
  //     });
  //   } else {
  //     _timers?.cancel();
  //   }

  //   setState(() {
  //     second = timer.totalSecond;
  //     _isRunning = !_isRunning;
  //   });
  // }

  // void resetTimer(
  //   BuildContext context,
  //   MyTimer timer,
  //   MyTimerModel model,
  // ) {
  //   _timers?.cancel();
  //   setState(() {
  //     timer.totalSecond = second;
  //     _isRunning = false;
  //   });
  // }
}
