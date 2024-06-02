import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/user.dart';
import 'package:muscle_training_app/models/menu_model/add_my_menu_to_memos_model.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/util/date_picker_item.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/view/menu/detail_menu_page.dart';
import 'package:provider/provider.dart';

class AddMyMenuToMemosPage extends StatefulWidget {
  const AddMyMenuToMemosPage({
    super.key,
    required this.menu,
    required this.menuIndex,
  });
  final dynamic menu;
  final int menuIndex;

  @override
  State<AddMyMenuToMemosPage> createState() => _AddMyMenuToMemosPageState();
}

class _AddMyMenuToMemosPageState extends State<AddMyMenuToMemosPage> {
  bool _isLoading = false;
  var now = DateTime.now();
  late DateTime date;

  Future<void> addMenuToMemos(
    BuildContext context,
    AddMyMenuToMemosModel model,
    dynamic menu,
    DateTime date,
  ) async {
    try {
      model.startLoding();
      String res = await model.addMenuToMemos(
        date,
      );
      if (res == successRes) {
        res = successAdd;
        model.endLoding();
        Navigator.of(context).pop();
        showSnackBar(res, context);
      } else {
        model.endLoding;
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

    return ChangeNotifierProvider<AddMyMenuToMemosModel>(
      create: (_) => AddMyMenuToMemosModel(widget.menu)..readMenu(context),
      child: Consumer<AddMyMenuToMemosModel>(
        builder: (context, model, child) {
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
                              color: linkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'メモに追加するマイメニュー',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Card(
                        // borderOnForeground: false,
                        shape: Border.symmetric(
                            vertical: BorderSide(
                          width: 7,
                          color: linkBlue,
                        )),
                        elevation: 4,
                        child: ListTile(
                          leading: const Icon(Icons.assignment),
                          title: Row(
                            children: [
                              Text(
                                'メニュー${widget.menuIndex + 1}: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${widget.menu['menuName']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            '最終更新日: ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: blackColor,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_back,
                          ),
                          dense: true,
                          tileColor: mainColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailMenuPage(menu: widget.menu),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: CupertinoButton(
                        color: blueColor,
                        onPressed: () async {
                          await addMenuToMemos(
                            context,
                            model,
                            widget.menu,
                            date,
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
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
