import 'package:flutter/material.dart';
import 'package:muscle_training_app/models/memo_model/table_memo_model.dart';
import 'package:provider/provider.dart';

Widget MenuWidget(
  BuildContext context,
  String date,
) {
  return ChangeNotifierProvider<TableMemoModel>(
    create: (_) => TableMemoModel()..fetchTableMemo(date),
    child: Scaffold(
      body: Center(
        child: Consumer<TableMemoModel>(
          builder: (context, model, child) {
            final List<dynamic>? memos = model.memos;

            if (memos == null) {
              return const CircularProgressIndicator();
            }

            if (memos.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 150,
                  ),
                  child: Text(
                    'メニューがありません',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            final List<Widget> widgets = memos
                .map((memo) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Table(
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              children: <TableRow>[
                                TableRow(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        memo['event'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${memo['weight']}kg',
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${memo['rep']}rep',
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        '${memo['set']}set',
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .cast<Widget>()
                .toList();
            return ListView(
              children: widgets,
            );
          },
        ),
      ),
    ),
  );
}
