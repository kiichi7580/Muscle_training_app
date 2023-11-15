import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/memo.dart';

class Table extends StatelessWidget {
  final List<Memo> memoList = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Data Table'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('種目', textAlign: TextAlign.center)),
                  DataColumn(label: Text('重量', textAlign: TextAlign.center)),
                  DataColumn(label: Text('セット数', textAlign: TextAlign.center)),
                  DataColumn(label: Text('回数', textAlign: TextAlign.center)),
                ],
                rows: memoList.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data.event, textAlign: TextAlign.center)),
                    DataCell(Text(
                        data.weight != null ? data.weight.toString() : '-',
                        textAlign: TextAlign.center)),
                    DataCell(Text(data.set != null ? data.set.toString() : '-',
                        textAlign: TextAlign.center)),
                    DataCell(Text(data.rep != null ? data.rep.toString() : '-',
                        textAlign: TextAlign.center)),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
