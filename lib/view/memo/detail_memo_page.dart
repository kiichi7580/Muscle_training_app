// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/models/memo_model/detail_memo_model.dart';
import 'package:muscle_training_app/view/memo/widgets/table_memo_widget.dart';

class DetailMemoPage extends StatefulWidget {
  const DetailMemoPage({
    super.key,
    required this.date,
    required this.uid,
  });
  final String date;
  final String uid;

  @override
  State<DetailMemoPage> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<DetailMemoPage> {
  late int dateId;
  bool isEditingMode = false;

  @override
  void initState() {
    super.initState();
    dateId = DetailMemoModel().dateToDateId(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailMemoModel>(
      create: (_) => DetailMemoModel(),
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: Text(
            '${widget.date}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isEditingMode = !isEditingMode;
                });
              },
              icon: Icon(
                Icons.edit,
                color: isEditingMode ? mainColor : blackColor,
              ),
            ),
          ],
          foregroundColor: blackColor,
          backgroundColor: blueColor,
        ),
        body: Center(
          child: Consumer<DetailMemoModel>(builder: (context, model, child) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('memos')
                  .where('uid', isEqualTo: widget.uid)
                  .orderBy('date', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: linkBlue,
                  );
                }

                List<Memo> memos = model.snapshotToMemoList(
                    snapshot: snapshot, dateId: dateId);

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
                return TableMemoWidget(
                  memos: memos,
                  isEditingMode: isEditingMode,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
