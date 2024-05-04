import 'package:flutter/material.dart';
import 'package:muscle_training_app/resources/timer_firestore_methods.dart';

class EditTimerModel extends ChangeNotifier {
  EditTimerModel(this.timer) {
    nameController.text = timer['timerName'];
    minuteController.text = timer['minute'];
    secondController.text = timer['second'];
  }
  final dynamic timer;

  final nameController = TextEditingController();
  final minuteController = TextEditingController();
  final secondController = TextEditingController();

  String timerName = '';
  String minute = '';
  String second = '';
  int? totalSeconds;
  bool _isLoading = false;
  bool get getLoading => _isLoading;

  void startLoading() {
    this._isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    this._isLoading = false;
    notifyListeners();
  }

  void setTimerName(String timerName) {
    this.timerName = timerName;
    notifyListeners();
  }

  void setMinute(String minute) {
    this.minute = minute;
    notifyListeners();
  }

  void setSecond(String second) {
    this.second = second;
    notifyListeners();
  }

  Future<String> update() async {
    this.timerName = nameController.text;
    this.minute = minuteController.text;
    this.second = secondController.text;

    String res = await TimerFireStoreMethods()
        .upDateTimer(timerName, minute, second, timer.id);

    return res;
  }
}
