// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/domain/user.dart';
import 'package:muscle_training_app/models/menu_model/edit_menuName_model.dart';
import 'package:muscle_training_app/models/menu_model/memo_widget_list_model.dart';
import 'package:muscle_training_app/models/menu_model/menu_model.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/menu_firestore_methods.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';

class EditMenuPage extends StatefulWidget {
  const EditMenuPage({super.key, required this.menu});
  final dynamic menu;

  @override
  State<EditMenuPage> createState() => _EditTimerPageState();
}

class _EditTimerPageState extends State<EditMenuPage> {
  String menuName = '';

  Future<void> upDate(
    BuildContext context,
    MemoWidgetListModel model,
    String uid,
    String menuId,
    String menuName,
    List<Memo> memos,
  ) async {
    try {
      setState(() {
        model.startLoding();
      });
      String res = await MenuFireStoreMethods().upDateMenu(
        uid,
        menuId,
        menuName,
        memos,
      );
      if (res == successRes) {
        res = successUpDate;
        model.endLoding();
        showSnackBar(res, context);
        Navigator.of(context).pop();
      } else {
        model.endLoding();
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final List<Memo> memoList =
        Provider.of<MenuModel>(context, listen: false).getMemoList;
    return ChangeNotifierProvider<MemoWidgetListModel>(
      create: (_) =>
          MemoWidgetListModel(widget.menu)..fetchEditMemoList(context),
      child: Consumer<MemoWidgetListModel>(
        builder: (context, model, child) {
          final memoWidgetList = model.memoWidgetList;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'マイメニューを編集',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await upDate(
                      context,
                      model,
                      user.uid,
                      widget.menu['id'],
                      this.menuName,
                      memoList,
                    );
                  },
                  child: Text(
                    '更新',
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              foregroundColor: blackColor,
              backgroundColor: blueColor,
            ),
            backgroundColor: greyColor,
            body: buildBody(
              context,
              memoWidgetList,
            ),
          );
        },
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    List<Widget> memoWidgetList,
  ) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    return ChangeNotifierProvider<EditMenuNameModel>(
      create: (_) => EditMenuNameModel(widget.menu),
      child: Consumer<EditMenuNameModel>(
        builder: (context, model, child) {
          this.menuName = model.menuNameController.text;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: screenWidth * 0.8,
                        child: TextField(
                          controller: model.menuNameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'メニュー名',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: borderColor,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onChanged: (text) {
                            model
                              ..menuName = text
                              ..setMenuName(text);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: memoWidgetList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                child: memoWidgetList[index],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
