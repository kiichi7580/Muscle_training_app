import 'package:flutter/material.dart';
import 'package:muscle_training_app/resources/memo_firestore_methods.dart';

class EditMemoModel extends ChangeNotifier {
  EditMemoModel(this.memo) {
    eventController.text = memo['event'];
    weightController.text = memo['weight'];
    setController.text = memo['set'];
    repController.text = memo['rep'];
    time = memo['time'];
    uid = memo['uid'];
  }
  final dynamic memo;

  final eventController = TextEditingController();
  final weightController = TextEditingController();
  final setController = TextEditingController();
  final repController = TextEditingController();

  String event = '';
  String weight = '';
  String set = '';
  String rep = '';
  String time = '';
  String uid = '';
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

  void setEvent(String event) {
    this.event = event;
    notifyListeners();
  }

  void setWeight(String weight) {
    this.weight = weight;
    notifyListeners();
  }

  void setSet(String set) {
    this.set = set;
    notifyListeners();
  }

  void setRep(String rep) {
    this.rep = rep;
    notifyListeners();
  }

  Future<String> update() async {
    this.event = eventController.text;
    this.weight = weightController.text;
    this.set = setController.text;
    this.rep = repController.text;

    String res = await MemoFireStoreMethods().upDateMemo(
      event,
      weight,
      set,
      rep,
      uid,
      time,
      memo.id,
    );
    return res;
  }
}
