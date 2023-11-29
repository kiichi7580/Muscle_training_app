import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/view_model/timer_model/display_timer_model.dart';
import 'package:provider/provider.dart';

class DisplayTimerPage extends StatefulWidget {
  const DisplayTimerPage({
    super.key,
    required this.maxSeconds,
    required this.seconds,
  });
  final int maxSeconds;
  final int seconds;

  @override
  State<DisplayTimerPage> createState() => _DisplayTimerPageState();
}

class _DisplayTimerPageState extends State<DisplayTimerPage> {
  final _audio = AudioPlayer();

  late int maxSeconds;
  // int maxSeconds = 10;
  late int seconds;
  // late int maxSeconds;
  // late int seconds;
  Timer? timer;

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    // seconds: 1
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        stopTimer(reset: false);
        seconds = maxSeconds;
      }
    });
  }

  void resetTimer() => setState(() => seconds = maxSeconds);

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DisplayTimerModel>(
        create: (_) =>
            DisplayTimerModel()..fetchDisplayTimer(maxSeconds, seconds),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('タイマー'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Container(
                width: double.infinity,
                color: Colors.black12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTimer(),
                    const SizedBox(height: 80),
                    buildButtons()
                  ],
                ))));
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;
    final timeController = TextEditingController();

    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 150,
                child: ElevatedButton(
                    child: Text(
                      isRunning ? 'ストップ' : 'スタート',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black26),
                    onPressed: () {
                      if (isRunning) {
                        stopTimer(reset: false);
                      } else {
                        startTimer(reset: false);
                      }
                    }),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 70,
                width: 150,
                child: ElevatedButton(
                    child: const Text(
                      'リセット',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black26),
                    onPressed: resetTimer),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 150,
                child: ElevatedButton(
                  child: const Text(
                    'スタート',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black26),
                  onPressed: () {
                    seconds = maxSeconds;
                    startTimer();
                  },
                ),
              ),
            ],
          );
  }

  Widget buildTimer() => SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1 - seconds / maxSeconds,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 12,
            backgroundColor: Colors.greenAccent,
          ),
          Center(
            child: buildTime(),
          )
        ],
      ));

  Widget buildTime() {
    return Text(
      '$seconds',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 80,
      ),
    );
  }

  // ウィジェットが作成された際に受け取る値を初期化
  @override
  void initState() {
    super.initState();
    maxSeconds = widget.maxSeconds;
    seconds = widget.seconds;
  }
}
