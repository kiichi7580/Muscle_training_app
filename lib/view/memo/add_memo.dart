import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/user.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/memo_firestore_methods.dart';
import 'package:muscle_training_app/util/date_picker_item.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class AddMemoPage extends StatefulWidget {
  const AddMemoPage({super.key});

  @override
  State<AddMemoPage> createState() => _AddMemoPageState();
}

class _AddMemoPageState extends State<AddMemoPage> {
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _setController = TextEditingController();
  final TextEditingController _repController = TextEditingController();
  bool _isLoading = false;
  var now = DateTime.now();
  late DateTime date;
  DateFormat format = DateFormat('yyyy年MM月dd日');

  Future<void> addMemo(
    BuildContext context,
    String event,
    String weight,
    String set,
    String rep,
    String uid,
    String time,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await MemoFireStoreMethods().addMemo(
        event,
        weight,
        set,
        rep,
        uid,
        time,
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

  // クパチーノデイトピッカーの関数
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return CupertinoPageScaffold(
      backgroundColor: mainColor,
      // キーボードの警告を消す
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'メモを追加',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: blackColor,
          ),
        ),
        backgroundColor: blueColor,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              DatePickerItem(
                children: <Widget>[
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 22,
                        color: blackColor,
                      ),
                      Text(
                        '日付',
                        style: TextStyle(
                          fontSize: 18,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: date,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        showDayOfWeek: true,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => date = newDate);
                        },
                      ),
                    ),
                    child: Text(
                      '${date.year}年${date.month}月${date.day}日(${date.weekday})',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
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
                    String formattedDate = format.format(date).toString();
                    await addMemo(
                      context,
                      _eventController.text,
                      _weightController.text,
                      _setController.text,
                      _repController.text,
                      user.uid,
                      formattedDate,
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
