import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/models/menu_model/menu_model.dart';
import 'package:muscle_training_app/view/menu/add_menu.dart';
import 'package:provider/provider.dart';

class MenuPage {
  Widget MyMenu(String uid) {
    return ChangeNotifierProvider<MenuModel>(
      create: (_) => MenuModel()..fetchMenu(),
      child: Scaffold(
        body: Center(
          child: Consumer<MenuModel>(
            builder: (context, model, child) {
              final List<dynamic>? menus = model.menus;

              if (menus == null) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }

              if (menus.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_add,
                        color: blackColor,
                        size: 45,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'メニューを追加しましょう',
                        style: TextStyle(
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // リストのindexを取得するためasMap関数を使用
              final List<Widget> widgets = menus.asMap().entries.map((entry) {
                int menuIndex = entry.key;
                dynamic menus = entry.value;
                return buildBody(context, menus, menuIndex, uid);
              }).toList();
              return ListView(
                children: widgets,
              );
            },
          ),
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            heroTag: '1',
            tooltip: 'メニューを追加する',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddMenuPage(),
                ),
              );
            },
            backgroundColor: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }

  Widget buildBody(
      BuildContext context, dynamic menu, int menuIndex, String uid) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              // 編集画面に遷移
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => EditTimerPage(timer: timer),
              //   ),
              // );
            },
            backgroundColor: blackColor,
            foregroundColor: mainColor,
            icon: Icons.edit,
            label: '編集',
          ),
          SlidableAction(
            onPressed: (context) async {
              final delete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('削除の確認'),
                  content: const Text('メニューを削除しますか？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('いいえ'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              );
              if (delete ?? false) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('menus')
                    .doc(menu.id)
                    .delete();
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: mainColor,
            icon: Icons.delete,
            label: '削除',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Card(
          borderOnForeground: false,
          shape: Border.all(
            width: 10,
            color: linkBlue,
          ),
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.assignment),
            title: Text(
              'メニュー${menuIndex + 1}: ${menu['menuName']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'メニュー一覧',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            trailing: Icon(
              Icons.arrow_back,
            ),
            dense: true,
            tileColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => DisplayTimerPage(
              //       timerName: timer['timerName'],
              //       totalSeconds: timer['totalSeconds'],
              //       dynamicSeconds: timer['totalSeconds'],
              //     ),
              //   ),
              // );
            },
          ),
        ),
      ),
    );
  }
}
