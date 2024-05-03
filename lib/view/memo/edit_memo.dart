import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/models/memo_model/edit_memo_model.dart';
import 'package:provider/provider.dart';

class EditMemoPage extends StatefulWidget {
  const EditMemoPage({super.key, required this.memo});
  final dynamic memo;

  @override
  State<EditMemoPage> createState() => _EditMemoPageState();
}

class _EditMemoPageState extends State<EditMemoPage> {
  Future<void> upDate(BuildContext context, EditMemoModel model) async {
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
                        labelText: eventTx,
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
                        labelText: weightTx,
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
                      controller: model.repController,
                      decoration: const InputDecoration(
                        labelText: repTx,
                      ),
                      onChanged: (text) {
                        model
                          ..rep = text
                          ..setRep(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: model.setController,
                      decoration: const InputDecoration(
                        labelText: setTx,
                      ),
                      onChanged: (text) {
                        model
                          ..set = text
                          ..setSet(text);
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
                          await upDate(context, model);
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
