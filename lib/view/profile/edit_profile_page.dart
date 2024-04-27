import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/models/profile_model/edit_profile_model.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final dynamic user;

  @override
  State<EditProfilePage> createState() => _EditMemoPageState();
}

class _EditMemoPageState extends State<EditProfilePage> {
  bool _isLoading = false;

  void upDate(EditProfileModel model) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await model.update();

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('プロフィールを更新しました', context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditProfileModel>(
      create: (_) => EditProfileModel(widget.user),
      child: Scaffold(
        // キーボードの警告を消す
        resizeToAvoidBottomInset: false,
        backgroundColor: mainColor,
        appBar: AppBar(
          title: const Text(
            'プロフィール編集',
            style: TextStyle(
              color: blackColor,
            ),
          ),
          backgroundColor: blueColor,
        ),
        body: Center(
          child: Consumer<EditProfileModel>(
            builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: model.userNameController,
                      decoration: const InputDecoration(
                        labelText: 'ユーザー名',
                      ),
                      onChanged: (text) {
                        model
                          ..username = text
                          ..setUsername(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: model.shortTermGoalsController,
                      decoration: const InputDecoration(
                        labelText: '短期目標',
                      ),
                      onChanged: (text) {
                        model
                          ..shortTermGoals = text
                          ..setShortTermGoals(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: model.longTermGoalsController,
                      decoration: const InputDecoration(
                        labelText: '長期目標',
                      ),
                      onChanged: (text) {
                        model
                          ..longTermGoals = text
                          ..setLongTermGoals(text);
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: CupertinoButton(
                        color: blueColor,
                        onPressed: () {
                          upDate(model);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          '更新する',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
