import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/models/memo_model/detail_memo_model.dart';
import 'package:muscle_training_app/resources/memo_firestore_methods.dart';
import 'package:muscle_training_app/util/show_confirm_dialog.dart';
import 'package:muscle_training_app/view/memo/edit_memo_page.dart';
import 'package:muscle_training_app/view/memo/widgets/memo_data_source.dart';
import 'package:muscle_training_app/view/memo/widgets/edit_or_delete_confirm_dialog.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TableMemoWidget extends StatefulWidget {
  TableMemoWidget({
    super.key,
    required this.memos,
    this.isEditingMode = false,
  });
  final List<Memo> memos;
  bool isEditingMode;

  @override
  State<TableMemoWidget> createState() => _TableMemoWidgetState();
}

class _TableMemoWidgetState extends State<TableMemoWidget> {
  late MemoDataSource _memoDataSource;

  @override
  void initState() {
    super.initState();
    _memoDataSource = MemoDataSource(widget.memos);
  }

  dynamic memoToDynamic(Memo memo) {
    Map<String, dynamic> dynamicMemo = memo.toJson();
    return dynamicMemo;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailMemoModel>(
      create: (_) => DetailMemoModel(),
      child: Consumer<DetailMemoModel>(
        builder: (context, model, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isEditingMode
                  ? Column(
                      children: [
                        // memos.length + 1 は上のラベル分
                        for (int i = 0; i < widget.memos.length + 1; i++) ...{
                          if (i == 0) ...{
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                          } else ...{
                            Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  dynamic dynamicMemo =
                                      memoToDynamic(widget.memos[i - 1]);
                                  print(dynamicMemo);
                                  final String? selectedText =
                                      await showDialog<String>(
                                          context: context,
                                          builder: (_) {
                                            return EditOrDeleteConfirmDialog(
                                                memo: dynamicMemo);
                                          });
                                  if (selectedText == editTx) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditMemoPage(memo: dynamicMemo),
                                      ),
                                    );
                                  } else if (selectedText == deleteTx) {
                                    await showConfirmDialog(
                                      context,
                                      dynamicMemo,
                                      await MemoFireStoreMethods().deleteMemo,
                                    );
                                  } else {}
                                },
                              ),
                            ),
                          }
                        }
                      ],
                    )
                  : SizedBox(),
              Expanded(
                child: SfDataGrid(
                  source: _memoDataSource,
                  frozenColumnsCount: 1,
                  rowHeight: MediaQuery.of(context).size.height * 0.06,
                  columns: <GridColumn>[
                    GridColumn(
                      columnName: 'event',
                      width: MediaQuery.of(context).size.width * 0.35,
                      label: Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Text(
                          '種目',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      allowEditing: true,
                    ),
                    GridColumn(
                      columnName: 'weight',
                      width: MediaQuery.of(context).size.width * 0.2,
                      label: Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Text(
                          '重量',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'rep',
                      width: MediaQuery.of(context).size.width * 0.2,
                      label: Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Text(
                          '回数',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'set',
                      width: MediaQuery.of(context).size.width * 0.25,
                      label: Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: Text(
                          'セット数',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
