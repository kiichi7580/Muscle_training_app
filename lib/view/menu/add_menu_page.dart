import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/domain/user.dart';
import 'package:muscle_training_app/models/menu_model/add_menu_model.dart';
import 'package:muscle_training_app/models/menu_model/menu_model.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/menu_firestore_methods.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/view/menu/widgets/add_memu_widgets.dart';
import 'package:provider/provider.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({super.key});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final TextEditingController _menuNameController = TextEditingController();
  bool _added = false;

  Future<void> addMenu(
    BuildContext context,
    AddMenuModel model,
    String uid,
    String menuName,
    List<Memo> memos,
  ) async {
    try {
      model.startLoding();
      String res = await MenuFireStoreMethods().addMenu(
        uid,
        menuName,
        memos,
      );
      if (res == successRes) {
        res = successAdd;
        model.endLoding();
        showSnackBar(res, context);
        Navigator.of(context).pop();
      } else {
        model.endLoding();
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  List<Widget> menuList = <Widget>[
    Builder(
      builder: (context) {
        return AddMenuWidget(context);
      },
    )
  ];

  List<Widget> _menuList = <Widget>[];

  @override
  void initState() {
    super.initState();
    _menuList = menuList;
  }

  @override
  void dispose() {
    super.dispose();
    _menuNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final List<Memo> memoList =
        Provider.of<MenuModel>(context, listen: false).getMemoList;
    return ChangeNotifierProvider<AddMenuModel>(
      create: (_) => AddMenuModel(),
      child: Consumer<AddMenuModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'マイメニューを追加',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await addMenu(
                      context,
                      model,
                      user.uid,
                      _menuNameController.text,
                      memoList,
                    );
                  },
                  child: Text(
                    '保存',
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
            body: buildBody(context, menuList),
            floatingActionButton: buildFloatingActionButton(
              context,
              model,
            ),
          );
        },
      ),
    );
  }

  void buttonPressed1(AddMenuModel model) {
    if (_added) {
      return menuList.add(
        AddMenuWidget(
          context,
          // onCheck(model),
          // model,
        ),
      );
    } else {}
    setState(() {
      _menuList = menuList;
    });
  }

  Widget buildBody(BuildContext context, List menuList) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
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
                    controller: _menuNameController,
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
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: menuList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          child: menuList[index],
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
  }

  Widget buildFloatingActionButton(
    BuildContext context,
    AddMenuModel model,
  ) {
    return FloatingActionButton(
      heroTag: '1',
      tooltip: 'メニューを追加する',
      onPressed: () {
        setState(() {
          _added = true;
        });
        buttonPressed1(model);
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
  }
}
