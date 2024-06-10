// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/models/my_menu_model/edit_my_menu_model.dart';
import 'package:muscle_training_app/models/my_menu_model/my_menu_model.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/widgets/text_field_input.dart';

Widget EditMyMenuWidget(BuildContext context, dynamic memo) {
  Size screenSize = MediaQuery.of(context).size;
  double screenWidth = screenSize.width;
  final MyMenuModel menuModel =
      Provider.of<MyMenuModel>(context, listen: false);
  return ChangeNotifierProvider<EditMyMenuModel>(
    create: (_) => EditMyMenuModel(memo),
    child: Consumer<EditMyMenuModel>(
      builder: (context, model, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: mainColor,
            border: Border.all(
              width: 2,
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: screenWidth * 0.65,
                    child: Material(
                      color: mainColor,
                      child: MemoTextField(
                        isEnabled: !model.getChecked,
                        labelText: eventTx,
                        textInputType: TextInputType.text,
                        textEditingController: model.eventController,
                        onChanged: (text) {
                          model
                            ..event = text
                            ..setEvent(text);
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.check_circle_outline,
                        size: 32,
                        color: model.getChecked
                            ? yesReactionColor
                            : noReactionColor,
                      ),
                      onPressed: model.getChecked
                          ? null
                          : () async {
                              String res = await model.EditMenu();
                              if (res == successRes) {
                                menuModel.setMemoList(model.memo);
                                model.checkedOK();
                              } else {
                                showSnackBar(res, context);
                              }
                            },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: screenWidth * 0.22,
                    child: Material(
                      color: mainColor,
                      child: MemoTextField(
                        isEnabled: !model.getChecked,
                        labelText: weightTx,
                        textInputType: TextInputType.number,
                        textEditingController: model.weightController,
                        onChanged: (text) {
                          model
                            ..weight = text
                            ..setWeight(text);
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.22,
                    child: Material(
                      color: mainColor,
                      child: MemoTextField(
                        isEnabled: !model.getChecked,
                        labelText: repTx,
                        textInputType: TextInputType.number,
                        textEditingController: model.repController,
                        onChanged: (text) {
                          model
                            ..rep = text
                            ..setRep(text);
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.22,
                    child: Material(
                      color: mainColor,
                      child: MemoTextField(
                        isEnabled: !model.getChecked,
                        labelText: setTx,
                        textInputType: TextInputType.number,
                        textEditingController: model.setController,
                        onChanged: (text) {
                          model
                            ..set = text
                            ..setSet(text);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      },
    ),
  );
}
