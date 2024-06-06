import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CupertinoSwitchTile extends StatelessWidget {
  const CupertinoSwitchTile({
    required this.content,
    required this.value,
    required this.onChanged,
  });

  final Widget content;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: null,
      title: content,
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
