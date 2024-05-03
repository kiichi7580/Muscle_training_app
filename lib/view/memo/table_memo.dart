import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/util/show_confirm_dialog.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/resources/memo_firestore_methods.dart';
import 'package:muscle_training_app/view/memo/edit_memo.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({
    super.key,
    required this.date,
    required this.uid,
  });
  final String date;
  final String uid;

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  int memoLen = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var memoSnap = await FirebaseFirestore.instance
          .collection('memos')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('time', isEqualTo: widget.date)
          .get();

      memoLen = memoSnap.docs.length;
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text(
          '${widget.date}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('memos')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('time', isEqualTo: widget.date)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot memo = (snapshot.data! as dynamic).docs[index];

              return Slidable(
                key: Key(memo['id']),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (BuildContext context) async {
                        //編集画面に遷移
                        final String? event = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditMemoPage(
                              memo: memo,
                            ),
                          ),
                        );

                        if (event != null) {
                          final snackBar = SnackBar(
                            backgroundColor: yesReactionColor,
                            content: Text('$eventを編集しました'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      backgroundColor: blackColor,
                      foregroundColor: mainColor,
                      icon: Icons.edit,
                      label: '編集',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        await showConfirmDialog(
                          context,
                          memo,
                          MemoFireStoreMethods().deleteMemo,
                        );
                      },
                      backgroundColor: deleteColor,
                      foregroundColor: mainColor,
                      icon: Icons.delete,
                      label: '削除',
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Table(
                            defaultColumnWidth: const IntrinsicColumnWidth(),
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      memo['event'],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      '${memo['weight']}kg',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      '${memo['set']}set',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      '${memo['rep']}rep',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
