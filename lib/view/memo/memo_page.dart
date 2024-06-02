import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/models/memo_model/memo_model.dart';
import 'package:muscle_training_app/view/memo/add_memo_page.dart';
import 'package:muscle_training_app/view/memo/detail_memo_page.dart';
import 'package:provider/provider.dart';

class MemoPage {
  Widget MemoList(String uid) {
    return ChangeNotifierProvider<MemoModel>(
      create: (_) => MemoModel()..fetchMemo(),
      child: Scaffold(
        body: Center(
          child: Consumer<MemoModel>(
            builder: (context, model, child) {
              final List<dynamic>? memos = model.memos;

              if (memos == null) {
                return const CircularProgressIndicator();
              }

              if (memos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.post_add,
                        color: blackColor,
                        size: 45,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'メモを追加しましょう',
                        style: TextStyle(
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final List<Widget> widgets = memos.map((memo) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.fitness_center),
                      dense: true,
                      tileColor: mainColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      title: Text(
                        memo.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onTap: () {
                        String dateToString = memo.toString();
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => DetailMemoPage(
                              date: dateToString,
                              uid: uid,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList();
              return ListView(
                children: widgets,
              );
            },
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return buildFloatingActionButton(context);
          },
        ),
      ),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: '1',
      tooltip: 'メニューを表示する',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddMemoPage(),
          ),
        );
      },
      backgroundColor: addFloationActionButtonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Icon(
        Icons.add,
      ),
    );
  }
}
