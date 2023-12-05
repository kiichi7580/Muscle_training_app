import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view_model/memo_model/add_memo_model.dart';
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
        appBar: AppBar(
          title: const Text('メモを追加'),
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
                          decoration: const InputDecoration(labelText: '種目'),
                          onChanged: (text) {
                            model.event = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: '重量'),
                          onChanged: (text) {
                            model.weight = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'セット数'),
                          onChanged: (text) {
                            model.set = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: '回数'),
                          onChanged: (text) {
                            model.rep = text;
                          },
                        ),
                        SizedBox(
                          height: 80,
                          child: TextButton(
                            onPressed: () => _pickDate(context, model),
                            child: const Text(
                              '日付を選択する',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: 350,
                          child: ElevatedButton(
                            onPressed: () async {
                              //追加の処理
                              try {
                                await model.addMemo();
                                Navigator.pop(context);
                              } catch (e) {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(e.toString()),
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

  Future<void> _pickDate(
    BuildContext context,
    AddMemoModel model,
  ) async {
    //DatePickerの初期値
    DateTime date = DateTime.now();
    late DateTime firstDay;
    late DateTime lastDay;
    final format1 = DateFormat('yyyy-MM-dd');

    //DatePickerを表示し、選択されたら変数に格納する
    final _selectedDay = await showDatePicker(
        locale: const Locale('ja'),
        context: context,
        initialDate: date,
        firstDate: firstDay =
            DateTime.now().subtract(const Duration(days: 1000)),
        lastDate: lastDay = DateTime.now().add(const Duration(days: 1000)),);

    //nullチェック
    if (_selectedDay != null) {
      //選択された日付を変数に格納
      setState(() {
        date = _selectedDay;
        model.time = format1.format(date);
      });
    } else {
      //nullならば何もしない
      return;
    }
  }
}
