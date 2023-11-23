import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  var backgroundColor;
  var color;

  ButtonWidget({
    Key? key,
    required this.text,
    this.color = Colors.white,
    required this.onClicked,
    this.backgroundColor = Colors.black,
  }) : super(key: key) {

  }

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black45,
      padding: EdgeInsets.symmetric(horizontal: 32,vertical: 16)
    ),
    onPressed: onClicked,
    child: Text(
      text,
      style: TextStyle(fontSize: 20, color: Colors.black45)
    ),
  );

}
