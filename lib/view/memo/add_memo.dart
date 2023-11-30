import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view_model/memo_model/add_memo_model.dart';
import 'package:provider/provider.dart';

class AddMemoPage extends StatelessWidget {
  const AddMemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddMemoModel>(
      create: (_) => AddMemoModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('メモを追加'),
        ),
        backgroundColor: mainColor,
        body: Center(
          child: Consumer<AddMemoModel>(
            builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: '種目'),
                          onChanged: (text) {
                            model.event = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: '重量'),
                          onChanged: (text) {
                            model.weight = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'セット数'),
                          onChanged: (text) {
                            model.set = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: '回数'),
                          onChanged: (text) {
                            model.rep = text;
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 50,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () async {
                              //追加の処理
                              try {
                                model.startLoding();
                                await model.addMemo();
                                Navigator.pop(context);
                              } catch (e) {
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
                            child: const Text(
                              '追加する',
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
                  if (model.isLoding)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
