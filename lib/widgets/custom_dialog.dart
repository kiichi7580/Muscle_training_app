import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({
    this.title = '',
    this.titleBackgroundColor = mainColor,
    this.content,
    this.actions,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
    Key? key,
  }) : super(key: key ?? UniqueKey());

  final String? title;
  final Color titleBackgroundColor;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mainColor,
      title: Container(
        padding: EdgeInsets.only(
          top: 40,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title ?? '',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: content,
      ),
      contentPadding: contentPadding,
      actions: actions,
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.symmetric(vertical: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}
