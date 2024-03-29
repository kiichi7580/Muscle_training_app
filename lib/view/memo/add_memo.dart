import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/models/memo_model/add_memo_model.dart';
import 'package:provider/provider.dart';

class AddMemoPage extends StatefulWidget {
  const AddMemoPage({
    super.key,
  });

  @override
  State<AddMemoPage> createState() => _AddMemoPageState();
}

class _AddMemoPageState extends State<AddMemoPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddMemoModel>(
      create: (_) => AddMemoModel(),
      child: Scaffold(
        // キーボードの警告を消す
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'メモを追加',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: blackColor,
                ),
          ),
          backgroundColor: blueColor,
        ),
        backgroundColor: mainColor,
        body: Center(
          child: Consumer<AddMemoModel>(
            builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: '種目',
                          ),
                          onChanged: (text) {
                            model.event = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '重量',
                          ),
                          onChanged: (text) {
                            model.weight = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'セット数',
                          ),
                          onChanged: (text) {
                            model.set = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '回数',
                          ),
                          onChanged: (text) {
                            model.rep = text;
                          },
                        ),
                        SizedBox(
                          height: 70,
                          child: Center(
                            child: displayDate(context, model),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: Center(
                            child: TextButton.icon(
                              onPressed: () => _pickDate(context, model),
                              icon: const Icon(
                                Icons.date_range,
                              ),
                              label: const Text(
                                '日付を選択する',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
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
                              //追加の処理
                              try {
                                model.startLoding;
                                await model.addMemo();
                                Navigator.pop(context);
                              } catch (e) {
                                final snackBar = SnackBar(
                                  backgroundColor: blackColor,
                                  content: Text(
                                    e.toString(),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } finally {
                                model.endLoding();
                              }
                            },
                            child: const Text(
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
                  if (model.isLoding)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget displayDate(
    BuildContext context,
    AddMemoModel model,
  ) {
    if (model.time != null) {
      return Text(
        '${model.time}',
        style: const TextStyle(
          fontSize: 18,
        ),
      );
    } else {
      final date = DateTime.now();
      final format1 = DateFormat('yyyy年MM月dd日');
      final formatdate = format1.format(date);
      return Text(
        formatdate,
        style: const TextStyle(
          fontSize: 18,
        ),
      );
    }
  }

  Future<void> _pickDate(
    BuildContext context,
    AddMemoModel model,
  ) async {
    //DatePickerの初期値
    DateTime date = DateTime.now();
    late DateTime firstDay;
    late DateTime lastDay;
    final format2 = DateFormat('yyyy年MM月dd日');

    //DatePickerを表示し、選択されたら変数に格納する
    final _selectedDay = await showDatePicker(
      locale: const Locale('ja'),
      context: context,
      initialDate: date,
      firstDate: firstDay = DateTime.now().subtract(const Duration(days: 1000)),
      lastDate: lastDay = DateTime.now().add(const Duration(days: 1000)),
    );

    //nullチェック
    if (_selectedDay != null) {
      //選択された日付を変数に格納
      setState(() {
        date = _selectedDay;
        model.time = format2.format(date);
      });
    } else {
      //nullならば何もしない
      return;
    }
  }
}
