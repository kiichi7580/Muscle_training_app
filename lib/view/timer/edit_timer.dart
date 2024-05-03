import 'package:flutter/cupertino.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/models/timer_model/edit_timer_model.dart';
import 'package:provider/provider.dart';

class EditTimerPage extends StatefulWidget {
  const EditTimerPage({super.key, required this.timer});
  final dynamic timer;

  @override
  State<EditTimerPage> createState() => _EditTimerPageState();
}

class _EditTimerPageState extends State<EditTimerPage> {
  Future<void> upDate(BuildContext context, EditTimerModel model) async {
    try {
      model.startLoading();
      String res = await model.update();
      if (res == successRes) {
        res = successUpDate;
        model.endLoading();
        Navigator.of(context).pop();
        showSnackBar(res, context);
      } else {
        model.endLoading();
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTimerModel>(
      create: (_) => EditTimerModel(widget.timer),
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: const Text(
            'タイマーを編集',
            style: TextStyle(
              color: blackColor,
            ),
          ),
          backgroundColor: blueColor,
        ),
        body: Center(
          child: Consumer<EditTimerModel>(
            builder: (context, model, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 90,
                            width: 294,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: model.nameController,
                                decoration: const InputDecoration(
                                  labelText: '名前',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (text) {
                                  model
                                    ..timerName = text
                                    ..setTimerName(text);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 90,
                                width: 130,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: model.minuteController,
                                    decoration: const InputDecoration(
                                      labelText: '分数を入力',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (text) {
                                      model
                                        ..minute = text
                                        ..setMinute(text);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 90,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    ':',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 90,
                                width: 130,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: model.secondController,
                                    decoration: const InputDecoration(
                                      labelText: '秒数を入力',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (text) {
                                      model
                                        ..second = text
                                        ..setSecond(text);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                            width: double.infinity,
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: CupertinoButton(
                              color: blueColor,
                              onPressed: () async {
                                await upDate(context, model);
                              },
                              child: const Text(
                                '変更する',
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
