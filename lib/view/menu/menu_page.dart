import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/models/menu_model/menu_model.dart';
import 'package:muscle_training_app/view/menu/add_my_menu_to_memos_page.dart';
import 'package:muscle_training_app/view/menu/detail_menu_page.dart';
import 'package:muscle_training_app/view/menu/edit_menu_page.dart';
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
        floatingActionButton: buildFloatingActionButton(),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMenuPage(menu: menu),
                ),
              );
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
                        foregroundColor: blackColor,
                      ),
                      child: const Text('いいえ'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: deleteColor,
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

                // メニュードキュメントに紐づくメモサブコレクションを取得して削除
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('menus')
                    .doc(menu.id)
                    .collection('memos')
                    .get()
                    .then((querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    doc.reference.delete();
                  });
                });
              }
            },
            backgroundColor: deleteColor,
            foregroundColor: mainColor,
            icon: Icons.delete,
            label: '削除',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Card(
          // borderOnForeground: false,
          shape: Border.symmetric(
              vertical: BorderSide(
            width: 7,
            color: linkBlue,
          )),
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.assignment),
            title: Row(
              children: [
                Text(
                  'メニュー${menuIndex + 1}: ',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${menu['menuName']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              '最終更新日: ',
              style: const TextStyle(
                fontSize: 12,
                color: blackColor,
              ),
            ),
            trailing: Icon(
              Icons.arrow_back,
            ),
            dense: true,
            tileColor: mainColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailMenuPage(menu: menu),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  buildFloatingActionButton() {
    return Builder(builder: (context) {
      final MenuModel menuModel =
          Provider.of<MenuModel>(context, listen: false);
      return FloatingActionButton(
        heroTag: '1',
        tooltip: 'マイメニューをメモに追加する',
        onPressed: () {
          showWidgetPicker(
              context, menuModel.getMenuNameList, menuModel.getMenus);
          print('menuModel.getMenuNameList: ${menuModel.getMenuNameList}');
        },
        backgroundColor: addFloationActionButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.add,
          color: mainColor,
        ),
      );
    });
  }

  void showWidgetPicker(
    BuildContext context,
    List<String> menuNameList,
    List<dynamic> menus,
  ) {
    Picker(
      adapter: PickerDataAdapter<String>(pickerData: menuNameList),
      headerColor: mainColor,
      confirmText: '選択',
      confirmTextStyle: TextStyle(
        color: linkBlue,
      ),
      cancelText: 'キャンセル',
      cancelTextStyle: TextStyle(
        color: blackColor,
      ),
      onConfirm: (Picker picker, List value) {
        final selectedWidget = menus[value[0]];
        // 選択されたウィジェットに対する処理をここに記述
        print('Selected Widget: ${selectedWidget['id']}');
        print('value: $value');
        print('value[0]: ${value[0]}');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                AddMyMenuToMemosPage(menu: selectedWidget, menuIndex: value[0]),
          ),
        );
      },
    ).showModal(context);
  }
}
