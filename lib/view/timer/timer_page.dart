import 'package:flutter/material.dart';
import 'dart:async';
import 'rest_timer.dart';

import 'package:audioplayers/audioplayers.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);



  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  // int _counter = 5;

  // @override
  // void initState() {
  //   super.initState();
  //   Timer.periodic(
  //     const Duration(seconds: 1),
  //         (Timer timer) {
  //       _counter--;
  //       setState(() {});
  //       if(_counter == 0){
  //         timer.cancel();
  //       }
  //     },
  //   );
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('title'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               '$_counter',
//               style: Theme
//                   .of(context)
//                   .textTheme
//                   .headlineMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

  int _second = 5;
  Timer? _timer;
  bool _isRunning = false;

  final _audio = AudioPlayer();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '$_second',
                  style: TextStyle(fontSize: 100),
              ),
              ElevatedButton(
                  onPressed: () {
                    stop();
                  },
                  child: Text(_isRunning ? 'ストップ':'スタート',
                  style: TextStyle(
                    color: _isRunning ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              ElevatedButton(
                onPressed: () {
                  resetTimer();
                },
                child: Text('リセット',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TextFormField(
          //   // The validator receives the text that the user has entered.
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter some text';
          //     }
          //     return null;
          //   },
          // ),
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void stop() {
    if (!_isRunning) {
      _timer = Timer.periodic(
          const Duration(seconds: 1),
              (timer) {
            setState(() {
              _second--;
            });

            if (_second == 0) {
              _audio.play(AssetSource("Clock-Alarm02-4(Button).mp3"));
              resetTimer();
              _isRunning = false;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestTimer(),
                ),
              );
            }
          }
      );
    } else {
      _timer?.cancel();
    }

    setState(() {
      _isRunning = !_isRunning;
    });
  }
  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _second = 5;
      _isRunning = false;
    });
  }
}