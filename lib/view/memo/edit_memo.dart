import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view_model/memo_model/edit_memo_model.dart';
import 'package:provider/provider.dart';

class EditMemoPage extends StatefulWidget {
  const EditMemoPage(this.memo, {super.key});
  final Memo memo;

  @override
  State<EditMemoPage> createState() => _EditMemoPageState();
}

class _EditMemoPageState extends State<EditMemoPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditMemoModel>(
      create: (_) => EditMemoModel(widget.memo),
      child: Scaffold(
        // キーボードの警告を消す
        resizeToAvoidBottomInset: false,
        backgroundColor: mainColor,
        appBar: AppBar(
          title: const Text(
            'メモを編集',
            style: TextStyle(
              color: blackColor,
            ),
          ),
          backgroundColor: blueColor,
        ),
        body: Center(
          child: Consumer<EditMemoModel>(
            builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: model.eventController,
                      decoration: const InputDecoration(
                        labelText: '種目',
                      ),
                      onChanged: (text) {
                        model
                          ..event = text
                          ..setEvent(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: model.weightController,
                      decoration: const InputDecoration(
                        labelText: '重量',
                      ),
                      onChanged: (text) {
                        model
                          ..weight = text
                          ..setEvent(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: model.setController,
                      decoration: const InputDecoration(
                        labelText: 'セット',
                      ),
                      onChanged: (text) {
                        model
                          ..set = text
                          ..setSet(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: model.repController,
                      decoration: const InputDecoration(
                        labelText: '回数',
                      ),
                      onChanged: (text) {
                        model
                          ..rep = text
                          ..setRep(text);
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
                        onPressed: () async {
                          //処理の追加
                          try {
                            model.isUpdated();
                            await model.update();
                            Navigator.of(context).pop(model.event);
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: blackColor,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
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
