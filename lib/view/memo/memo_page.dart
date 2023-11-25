import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/constant/colors.dart';

import 'package:muscle_training_app/view/memo/add_memo.dart';
import 'package:muscle_training_app/view_model/memo_model/memo_model.dart';
import 'package:muscle_training_app/view/memo/edit_memo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view/memo/table_memo.dart';
// import '../login/login_page.dart';

class MemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemoModel>(
      create: (_) => MemoModel()..fetchMemo(),
      child: Scaffold(
        backgroundColor: mainColor,
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       await Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => LoginPage(),
        //           fullscreenDialog: true,
        //         ),
        //       );
        //     },
        //     icon: Icon(Icons.person),
        //   ),
        // ],
        // ),
        body: Center(
          child: Consumer<MemoModel>(builder: (context, model, child) {
            final List<dynamic>? memos = model.memos;

            if (memos == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = memos.map((memo) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.check_circle),
                    dense: true,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    title: Text(
                      memo.toString(),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TableWidget(date: memo.toString()),
                          ));
                    },
                  ),
                ),
              );
            }).toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<MemoModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              //画面遷移
              final bool? added = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMemoPage(),
                  fullscreenDialog: true,
                ),
              );

              if (added != null && added) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('メモを追加しました'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              model.fetchMemo();
            },
            tooltip: 'メモを追加する',
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }

  Future showConfirmDialog(
    BuildContext context,
    Memo memo,
    MemoModel model,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("削除の確認"),
            content: Text("${memo}のメニューを削除しますか？"),
            actions: [
              TextButton(
                  child: Text("いいえ"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                child: Text("はい"),
                onPressed: () async {
                  //modelで削除
                  await model.delete(memo);
                  Navigator.pop(context);
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('${memo}のメニューを削除しました'),
                  );
                  model.fetchMemo();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ],
          );
        });
  }
}
