import 'package:flutter/material.dart';
import 'package:muscle_training_app/resources/profile_firestore_methods.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(this.user) {
    userNameController.text = user['username'];
    photoUrlController.text = user['photoUrl'];
    descriptionController.text = user['description'];
  }
  final dynamic user;

  final userNameController = TextEditingController();
  final photoUrlController = TextEditingController();
  final descriptionController = TextEditingController();

  String username = '';
  String photoUrl = '';
  String description = '';

  void setUsername(String username) {
    this.username = username;
    notifyListeners();
  }

  void setPhotoUrl(String photoUrl) {
    this.photoUrl = photoUrl;
    notifyListeners();
  }

  void setDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  Future<String> update() async {
    this.username = userNameController.text;
    this.photoUrl = photoUrlController.text;
    this.description = descriptionController.text;

    String res = await ProfileFireStoreMethods().upDateProfile(
      username,
      photoUrl,
      description,
      user['uid'],
    );
    return res;
  }
}
