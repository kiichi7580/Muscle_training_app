// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/memo.dart';

class AddMenuModel extends ChangeNotifier {
  bool _checked = false;
  bool _isLoding = false;
  bool get getChecked => _checked;

  List<Memo> get getMemosList => memosList;

  void startLoding() {
    _isLoding = true;
    notifyListeners();
  }

  void endLoding() {
    _isLoding = false;
    notifyListeners();
  }

  void checkedNO() {
    _checked = false;
    notifyListeners();
  }

  void checkedOK() {
    _checked = true;
    notifyListeners();
  }

  final eventController = TextEditingController();
  final weightController = TextEditingController();
  final repController = TextEditingController();
  final setController = TextEditingController();

  String event = '';
  String weight = '';
  String rep = '';
  String set = '';
  Memo? memo;
  List<Memo> memosList = [];

  void setEvent(String event) {
    this.event = event;
    notifyListeners();
  }

  void setWeight(String weight) {
    this.weight = weight;
    notifyListeners();
  }

  void setRep(String rep) {
    this.rep = rep;
    notifyListeners();
  }

  void setSet(String set) {
    this.set = set;
    notifyListeners();
  }

  Future<String> addMenu() async {
    this.event = eventController.text;
    this.weight = weightController.text;
    this.rep = repController.text;
    this.set = setController.text;

    String res = '';
    if (eventController.text.isEmpty) {
      return res = eventFieldEmpty;
    } else if (weightController.text.isEmpty) {
      return res = weightFieldEmpty;
    } else if (repController.text.isEmpty) {
      return res = repFieldEmpty;
    } else if (setController.text.isEmpty) {
      return res = setFieldEmpty;
    }
    this.memo = Memo(
      event: eventController.text,
      weight: weightController.text,
      rep: repController.text,
      set: setController.text,
    );

    notifyListeners();
    return res = successRes;
  }
}
