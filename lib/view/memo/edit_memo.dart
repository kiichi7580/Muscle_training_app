import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view_model/memo_model/edit_memo_model.dart';
import 'package:provider/provider.dart';

class EditMemoPage extends StatelessWidget {
  const EditMemoPage(this.memo, {super.key});
  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditMemoModel>(
      create: (_) => EditMemoModel(memo),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('メモを編集'),
        ),
        body: Center(
          child: Consumer<EditMemoModel>(
            builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      controller: model.eventController,
                      decoration: const InputDecoration(
                        labelText: '種目',
                      ),
                      onChanged: (text) {
                        model..event = text
                        ..setEvent(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: model.weightController,
                      decoration: const InputDecoration(
                        labelText: '重量',
                      ),
                      onChanged: (text) {
                        model..weight = text
                        ..setEvent(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: model.setController,
                      decoration: const InputDecoration(
                        labelText: 'セット',
                      ),
                      onChanged: (text) {
                        model..set = text
                        ..setSet(text);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: model.repController,
                      decoration: const InputDecoration(
                        labelText: '回数',
                      ),
                      onChanged: (text) {
                        model..rep = text
                        ..setRep(text);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 50,
                      width: 120,
                      child: ElevatedButton(
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
                        child: const Text(
                          '更新する',
                          style: TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w600,
                          ),),
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
