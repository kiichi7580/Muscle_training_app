// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view/memo/widgets/table_memo_widget.dart';
import 'package:muscle_training_app/view/my_menu/add_menu_to_my_menu_page.dart';

class DetailMyMenuPage extends StatefulWidget {
  const DetailMyMenuPage({
    super.key,
    required this.menu,
  });
  final dynamic menu;

  @override
  State<DetailMyMenuPage> createState() => _DetailMyMenuPageState();
}

class _DetailMyMenuPageState extends State<DetailMyMenuPage> {
  int memoListLen = 0;
  List<Memo> memos = [];

  @override
  void initState() {
    super.initState();
  }

  void _navigateToAddMenuPage(BuildContext context) async {
    Memo? newMemo = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMenuToMyMenuPage(menu: widget.menu),
      ),
    );
    if (newMemo != null) {
      // 新しいメモが追加された場合、リストに追加して更新
      setState(() {
        memos.add(newMemo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text(
          '${widget.menu['menuName']}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.menu['uid'])
            .collection('menus')
            .doc(widget.menu['id'])
            .collection('memos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: linkBlue,
            );
          }

          memos = snapshot.data!.docs.map((doc) {
            return Memo(
              id: doc['id'],
              event: doc['event'],
              weight: doc['weight'],
              rep: doc['rep'],
              set: doc['set'],
            );
          }).toList();

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
          );
        },
      ),
      floatingActionButton: buildFloatingActionButton(memos),
    );
  }

  buildFloatingActionButton(List<Memo> memos) {
    return Builder(builder: (context) {
      return SpeedDial(
        icon: Icons.add,
        backgroundColor: addFloationActionButtonColor,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: Icon(Icons.assignment_add),
            label: 'このマイメニューにメニューを追加する',
            backgroundColor: addFloationActionButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onTap: () async {
              _navigateToAddMenuPage(context);
            },
          ),
        ],
      );
    });
  }
}
