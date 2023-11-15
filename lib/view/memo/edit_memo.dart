import 'package:flutter/material.dart';
import 'package:muscle_training_app/view_model/memo_model/edit_memo_model.dart';
import 'package:provider/provider.dart';

import 'package:muscle_training_app/domain/memo.dart';

class EditMemoPage extends StatelessWidget {
  final Memo memo;
  EditMemoPage(this.memo);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditMemoModel>(
      create: (_) => EditMemoModel(memo),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('メモを編集'),
        ),
        body: Center(
          child: Consumer<EditMemoModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.eventController,
                    decoration: InputDecoration(
                      hintText: '種目',
                    ),
                    onChanged: (text) {
                      model.event = text;
                      model.setEvent(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.weightController,
                    decoration: InputDecoration(
                      hintText: '重量',
                    ),
                    onChanged: (text) {
                      model.weight = text;
                      model.setEvent(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.setController,
                    decoration: InputDecoration(
                      hintText: 'セット',
                    ),
                    onChanged: (text) {
                      model.set = text;
                      model.setSet(text);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: model.repController,
                    decoration: InputDecoration(
                      hintText: '回数',
                    ),
                    onChanged: (text) {
                      model.rep = text;
                      model.setRep(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            //処理の追加
                            try {
                              await model.update();
                              Navigator.of(context).pop(model.event);
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: Text('更新する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
