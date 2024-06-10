// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/resources/menu_firestore_methods.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/user.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/widgets/text_field_input.dart';

class AddMenuToMyMenuPage extends StatefulWidget {
  const AddMenuToMyMenuPage({
    super.key,
    required this.menu,
  });
  final dynamic menu;

  @override
  State<AddMenuToMyMenuPage> createState() => _AddMenuToMyMenuPageState();
}

class _AddMenuToMyMenuPageState extends State<AddMenuToMyMenuPage> {
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _setController = TextEditingController();
  final TextEditingController _repController = TextEditingController();
  bool _isLoading = false;
  var now = DateTime.now();
  late DateTime date;

  Future<void> addMenuToMyMenu(
    BuildContext context,
    String uid,
    String menuId,
    Memo memo,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await MenuFireStoreMethods().addMenuToMyMenu(
        uid,
        menuId,
        memo,
      );
      if (res == successRes) {
        res = successAdd;
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          Navigator.of(context).pop(memo);
        }
        showSnackBar(res, context);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    date = now;
  }

  @override
  void dispose() {
    super.dispose();
    _eventController.dispose();
    _weightController.dispose();
    _setController.dispose();
    _repController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: mainColor,
      // キーボードの警告を消す
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'メモを追加',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ),
        backgroundColor: blueColor,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Material(
                child: MemoTextField(
                  labelText: eventTx,
                  textInputType: TextInputType.text,
                  textEditingController: _eventController,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Material(
                child: MemoTextField(
                  labelText: weightTx,
                  textInputType: TextInputType.number,
                  textEditingController: _weightController,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Material(
                child: MemoTextField(
                  labelText: repTx,
                  textInputType: TextInputType.number,
                  textEditingController: _repController,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Material(
                child: MemoTextField(
                  labelText: setTx,
                  textInputType: TextInputType.number,
                  textEditingController: _setController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: CupertinoButton(
                  color: blueColor,
                  onPressed: () async {
                    await addMenuToMyMenu(
                      context,
                      user.uid,
                      widget.menu['id'],
                      Memo(
                        event: _eventController.text,
                        weight: _weightController.text,
                        set: _setController.text,
                        rep: _repController.text,
                      ),
                    );
                  },
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: linkBlue,
                        )
                      : Text(
                          '追加する',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
