import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/memo.dart';

class EditMemoModel extends ChangeNotifier {
  EditMemoModel(this.memo) {
    eventController.text = memo.event;
    weightController.text = memo.weight;
    setController.text = memo.set;
    repController.text = memo.rep;
  }
  final Memo memo;

  final eventController = TextEditingController();
  final weightController = TextEditingController();
  final setController = TextEditingController();
  final repController = TextEditingController();

  String? event;
  String? weight;
  String? set;
  String? rep;

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

  bool isUpdated() {
    return event != null || weight != null || set != null || rep != null;
  }

  Future<void> update() async {
    this.event = eventController.text;
    this.weight = weightController.text;
    this.set = setController.text;
    this.rep = repController.text;

    // firestoreに追加
    await FirebaseFirestore.instance.collection('memos').doc(memo.id).update({
      'event': event,
      'weight': weight,
      'set': set,
      'rep': rep,
    });
  }
}
