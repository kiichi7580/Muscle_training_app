import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/memo/add_memo.dart';
import 'package:muscle_training_app/view/memo/memo_page.dart';
import 'package:muscle_training_app/view/menu/add_menu_page.dart';
import 'package:muscle_training_app/view/menu/menu_page.dart';

class TabMemoPage extends StatefulWidget {
  const TabMemoPage({
    super.key,
    required this.uid,
  });
  final String uid;

  @override
  State<TabMemoPage> createState() => _MemoTabPageState();
}

class _MemoTabPageState extends State<TabMemoPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'メモ',
          style: TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          indicatorColor: heavyBlueColor,
          dividerColor: Colors.white70,
          dividerHeight: 48,
          labelStyle: TextStyle(
            color: heavyBlueColor,
            fontWeight: FontWeight.bold,
          ),
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'マイメニュー',
            ),
            Tab(
              text: 'メモ一覧',
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      _tabController.index == 0 ? AddMenuPage() : AddMemoPage(),
                ),
              );
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Expanded(
            child: buildTabBarView(_tabController),
          ),
        ],
      ),
    );
  }

  Widget buildTabBarView(TabController tabController) {
    return TabBarView(
      controller: tabController,
      children: [
        MenuPage().MyMenu(widget.uid),
        MemoPage().MemoList(widget.uid),
      ],
    );
  }
}
