// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/memo.dart';

class EditMenuModel extends ChangeNotifier {
  EditMenuModel(this.memo) {
    eventController.text = memo['event'];
    weightController.text = memo['weight'];
    setController.text = memo['set'];
    repController.text = memo['rep'];
    memoId = memo['id'];
  }
  dynamic memo;

  final eventController = TextEditingController();
  final weightController = TextEditingController();
  final setController = TextEditingController();
  final repController = TextEditingController();

  String event = '';
  String weight = '';
  String set = '';
  String rep = '';
  String memoId = '';

  bool _checked = false;
  bool get getChecked => _checked;

  void checkedNO() {
    _checked = false;
    notifyListeners();
  }

  void checkedOK() {
    _checked = true;
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

  Future<String> EditMenu() async {
    String res = failureUpDate;
    this.event = eventController.text;
    this.weight = weightController.text;
    this.set = setController.text;
    this.rep = repController.text;

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
      id: memoId,
      event: eventController.text,
      weight: weightController.text,
      rep: repController.text,
      set: setController.text,
    );
    notifyListeners();
    return res = successRes;
  }
}
