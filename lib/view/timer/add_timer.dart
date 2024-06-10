// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/view/timer/widgets/custom_picker.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/user.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/timer_firestore_methods.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';

class AddTimerPage extends StatefulWidget {
  const AddTimerPage({super.key});

  @override
  State<AddTimerPage> createState() => _AddTimerPageState();
}

class _AddTimerPageState extends State<AddTimerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  bool _isLoading = false;
  DateTime selectedTime = DateTime(0, 0, 0, 0, 0, 0, 0, 0);

  Future<void> addTimer(
    BuildContext context,
    String uid,
    String name,
    String minute,
    String second,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await TimerFireStoreMethods().addTimer(
        uid,
        name,
        minute,
        second,
      );
      if (res == successRes) {
        res = successAdd;
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
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
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text(
          'タイマーを追加',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Text(
            selectedTime == DateTime(0, 0, 0, 0, 0, 0, 0, 0)
                ? '00:00'
                : '${_minuteController.text}:${_secondController.text}',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: heavyBlueColor,
              backgroundColor: mainColor,
              side: BorderSide(color: heavyBlueColor),
            ),
            onPressed: () {
              DatePicker.showPicker(
                context,
                showTitleActions: true,
                onChanged: (date) {
                  selectedTime = date;
                  setState(() {
                    _minuteController.text = DateFormat("mm").format(date);
                    _secondController.text = DateFormat("ss").format(date);
                  });
                },
                onConfirm: (time) {
                  setState(() {});
                  _minuteController.text = DateFormat("mm").format(time);
                  _secondController.text = DateFormat("ss").format(time);
                },
                pickerModel: CustomPicker(
                  currentTime: selectedTime,
                ),
                locale: LocaleType.jp,
              );
            },
            child: const Text(
              '時間設定',
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: '名前',
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: CupertinoButton(
              color: blueColor,
              onPressed: () async {
                await addTimer(
                  context,
                  user.uid,
                  _nameController.text,
                  _minuteController.text,
                  _secondController.text,
                );
              },
              child: const Text(
                '保存する',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
        ],
      ),
    );
  }
}
