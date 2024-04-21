import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';


class DisplayTimerPage extends StatefulWidget {
  const DisplayTimerPage({
    super.key,
    required this.timerName,
    required this.totalSeconds,
    required this.dynamicSeconds,
  });
  final String timerName;
  final int totalSeconds;
  final int dynamicSeconds;

  @override
  State<DisplayTimerPage> createState() => _DisplayTimerPageState();
}

class _DisplayTimerPageState extends State<DisplayTimerPage> {
  late String timerName;
  late int totalSeconds;
  late int dynamicSeconds;
  Timer? timer;
  final audioCache = AudioCache();
  final audioPlayer = AudioPlayer();

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    // seconds: 1
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (dynamicSeconds > 0) {
        setState(() => dynamicSeconds--);
      } else {
        stopTimer(reset: false);
        dynamicSeconds = totalSeconds;
      }
    });
  }

  void resetTimer() => setState(() => dynamicSeconds = totalSeconds);

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'タイマー',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: mainColor),
        ),
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black26,
              Colors.black45,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  timerName,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            buildTimer(),
            const SizedBox(height: 80),
            buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = dynamicSeconds == totalSeconds || dynamicSeconds == 0;

    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black26,
                  ),
                  onPressed: () {
                    if (isRunning) {
                      stopTimer(reset: false);
                    } else {
                      startTimer(reset: false);
                    }
                  },
                  child: Text(
                    isRunning ? 'ストップ' : 'スタート',
                    style: const TextStyle(
                      color: mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 70,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black26,
                  ),
                  onPressed: resetTimer,
                  child: const Text(
                    'リセット',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black26,
                  ),
                  onPressed: () {
                    dynamicSeconds = totalSeconds;
                    startTimer();
                  },
                  child: const Text(
                    'スタート',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget buildTimer() => SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1 - dynamicSeconds / totalSeconds,
              valueColor: const AlwaysStoppedAnimation(mainColor),
              strokeWidth: 15,
              backgroundColor: Colors.greenAccent,
            ),
            Center(
              child: buildTime(),
            ),
          ],
        ),
      );

  Widget buildTime() {
    if (dynamicSeconds == 0) {
      playSound();
      return Text(
        '$dynamicSeconds',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: mainColor,
          fontSize: 80,
        ),
      );
    } else {
      return Text(
        '$dynamicSeconds',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: mainColor,
          fontSize: 80,
        ),
      );
    }
  }

  // 音が鳴るはずの関数
  Future<void> playSound() async {
    await audioCache.load('assets/Clock-Alarm02-4(Button).mp3');
    await audioPlayer.play(UrlSource('assets/Clock-Alarm02-4(Button).mp3'));
  }

  // ウィジェットが作成された際に受け取る値を初期化
  @override
  void initState() {
    super.initState();
    timerName = widget.timerName;
    totalSeconds = widget.totalSeconds;
    dynamicSeconds = widget.dynamicSeconds;
    audioCache.load('assets/Clock-Alarm02-4(Button).mp3');
  }
}
