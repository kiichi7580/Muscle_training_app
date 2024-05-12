import 'package:flutter/material.dart';

Future<void> imageDialog(BuildContext context, String imageUrl) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: imageUrl == 'assets/icons/1024 1.png'
            ? Image.asset(
                imageUrl,
                fit: BoxFit.cover, //写真が周りに目一杯広がるようにする
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover, //写真が周りに目一杯広がるようにする
              ),
      );
    },
  );
}
