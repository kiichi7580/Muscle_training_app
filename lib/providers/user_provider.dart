import 'package:flutter/material.dart';
import 'package:muscle_training_app/resources/auth_methods.dart';
import 'package:muscle_training_app/domain/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  bool _loading = false;

  User get getUser => _user!;

  bool get getLoading => _loading;

  void startLoading() {
    _loading = true;
    notifyListeners();
  }

  void endLoading() {
    _loading = false;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
