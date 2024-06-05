// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:muscle_training_app/resources/profile_firestore_methods.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(this.user) {
    userNameController.text = user['username'];
    shortTermGoalsController.text = user['shortTermGoals'];
    longTermGoalsController.text = user['longTermGoals'];
  }
  final dynamic user;

  final userNameController = TextEditingController();
  final shortTermGoalsController = TextEditingController();
  final longTermGoalsController = TextEditingController();

  String username = '';
  String shortTermGoals = '';
  String longTermGoals = '';

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
  }

  void setShortTermGoals(String shortTermGoals) {
    this.shortTermGoals = shortTermGoals;
    notifyListeners();
  }

    void setLongTermGoals(String longTermGoals) {
    this.longTermGoals = longTermGoals;
    notifyListeners();
  }

  Future<String> update() async {
    this.username = userNameController.text;
    this.shortTermGoals = shortTermGoalsController.text;
    this.longTermGoals = longTermGoalsController.text;

    String res = await ProfileFireStoreMethods().upDateProfile(
      username,
      shortTermGoals,
      longTermGoals,
      user['uid'],
    );
    return res;
  }
}
