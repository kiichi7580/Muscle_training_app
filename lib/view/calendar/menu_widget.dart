import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view_model/memo_model/table_memo_model.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key, required this.date});
  final String date;

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TableMemoModel>(
      create: (_) => TableMemoModel()..fetchTableMemo(widget.date),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: Center(
            child: Consumer<TableMemoModel>(
              builder: (context, model, child) {
                final List<Memo>? memos = model.memos;

                if (memos == null) {
                  return const CircularProgressIndicator();
                }

                if (memos.isEmpty) {
                  return const Center(
                    child: Text('メニューがありません'),
                  );
                }

                final List<Widget> widgets = memos
                    .map((memo) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: SafeArea(
                          top: false,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Table(
                                  defaultColumnWidth:
                                      const IntrinsicColumnWidth(),
                                  children: <TableRow>[
                                    TableRow(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            memo.event,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            '${memo.weight}kg',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            '${memo.set}set',
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            '${memo.rep}rep',
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
      ),
    );
  }
}
