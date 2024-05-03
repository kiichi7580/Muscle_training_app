import 'package:flutter/material.dart';

class EditMenuNameModel extends ChangeNotifier {
  EditMenuNameModel(this.menu) {
    menuNameController.text = menu['menuName'];
  }
  final dynamic menu;

  final menuNameController = TextEditingController();

  String menuName = '';

  void setMenuName(String menuName) {
    this.menuName = menuName;
    notifyListeners();
  }
}
