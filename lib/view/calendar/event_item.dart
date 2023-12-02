import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/domain/calendar.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
    required this.event,
    required this.onDelete,
    this.onTap,
  });
  final Calendar event;
  final Function() onDelete;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat('yyyy年M月d日hh時mm分');
    DateTime date1 = event.date;
    String FormatedDate = format.format(date1);

    return ListTile(
      title: Text(
        event.title,
      ),
      subtitle: Text(
        FormatedDate,
      ),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
