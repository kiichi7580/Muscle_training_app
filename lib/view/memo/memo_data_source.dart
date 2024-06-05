// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/domain/memo.dart';

class MemoDataSource extends DataGridSource {
  MemoDataSource(List<Memo> memos) {
    dataGridRows = memos
        .map<DataGridRow>(
          (dataGridRows) => DataGridRow(
            cells: [
              DataGridCell(
                columnName: 'event',
                value: dataGridRows.event,
              ),
              DataGridCell(
                columnName: 'weight',
                value: '${dataGridRows.weight}kg',
              ),
              DataGridCell(
                columnName: 'rep',
                value: '${dataGridRows.rep}rep',
              ),
              DataGridCell(
                columnName: 'set',
                value: '${dataGridRows.set}set',
              ),
            ],
          ),
        )
        .toList();
  }
  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: mainColor,
      cells: row.getCells().map<Widget>((dataGridCell) {
        return InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            alignment: Alignment.center,
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
    );
  }
}
