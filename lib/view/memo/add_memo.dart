import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/rendering.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:provider/provider.dart';
import 'package:muscle_training_app/view_model/memo_model/add_memo_model.dart';
import 'package:muscle_training_app/view/memo/table_memo.dart';

class AddMemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddMemoModel>(
      create: (_) => AddMemoModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('メモを追加'),
        ),
        body: Center(
          child: Consumer<AddMemoModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: '種目',
                        ),
                        onChanged: (text) {
                          model.event = text;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '重量',
                        ),
                        onChanged: (text) {
                          model.weight = text;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'セット数',
                        ),
                        onChanged: (text) {
                          model.set = text;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: '回数',
                        ),
                        onChanged: (text) {
                          model.rep = text;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          //追加の処理
                          try {
                            model.startLoding();
                            await model.addMemo();
                          } catch (e) {
                            print(e);
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
                        child: Text('追加する'),
                      ),
                    ],
                  ),
                ),
                if (model.isLoding)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
