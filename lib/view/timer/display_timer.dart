import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as audioplayers;
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
  int _countDown = 4; // 準備時間（秒）
  bool _isPreparing = false;
  bool _isRunning = false;
  final audioplayers.AudioPlayer _audioPlayer = audioplayers.AudioPlayer();
  audioplayers.AssetSource? _audioPlayerSource;

  void startTimer({bool reset = true}) {
    setState(() {
      _isPreparing = true;
    });
    playSoundStartTimer();
    if (reset) {
      resetTimer();
    }
    dynamicTimer();
  }

  void dynamicTimer() {
    // 3秒の準備時間を設ける
    timer = Timer(Duration(seconds: _countDown), () {
      // 準備時間が経過した後にタイマーを開始する
      setState(() {
        _isPreparing = false;
      });
      _audioPlayer.stop();
      // seconds: 1
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (dynamicSeconds > 0) {
          setState(() => dynamicSeconds--);
        } else {
          stopTimer(reset: false);
          dynamicSeconds = totalSeconds;
        }
      });
    });
  }

  void resetTimer() {
    _audioPlayer.stop();
    setState(() => dynamicSeconds = totalSeconds);
  }

  void stopTimer({bool reset = true}) {
    _audioPlayer.stop();
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
          timerName,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
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
                child: _isPreparing || _isRunning
                    ? Text(
                        _isPreparing ? '準備中...' : 'トレーニング中...',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : SizedBox(),
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
    _isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = dynamicSeconds == totalSeconds || dynamicSeconds == 0;

    return _isRunning || !isCompleted && !_isPreparing
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
                    if (_isRunning) {
                      stopTimer(reset: false);
                    } else {
                      startTimer(reset: false);
                    }
                  },
                  child: Text(
                    _isRunning ? 'ストップ' : 'スタート',
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
                width: 230,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black26,
                  ),
                  onPressed: () {
                    dynamicSeconds = totalSeconds;
                    startTimer();
                  },
                  child: Text(
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
      setState(() {
        _isRunning = false;
      });
      playSoundTimeUp();
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

  // タイマー開始準備時の音源
  Future<void> playSoundStartTimer() async {
    await _audioPlayer.setReleaseMode(audioplayers.ReleaseMode.loop);
    _audioPlayerSource = audioplayers.AssetSource('sounds/time_start.mp3');
    _audioPlayer.play(_audioPlayerSource!);
  }

  // タイマー終了時の音源
  Future<void> playSoundTimeUp() async {
    await _audioPlayer.setReleaseMode(audioplayers.ReleaseMode.loop);
    _audioPlayerSource = audioplayers.AssetSource('sounds/timeup.mp3');
    _audioPlayer.play(_audioPlayerSource!);
  }

  // ウィジェットが作成された際に受け取る値を初期化
  @override
  void initState() {
    super.initState();
    timerName = widget.timerName;
    totalSeconds = widget.totalSeconds;
    dynamicSeconds = widget.dynamicSeconds;
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
