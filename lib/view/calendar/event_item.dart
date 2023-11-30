import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/calendar.dart';

class EventItem extends StatelessWidget {
  final Calendar event;
  final Function() onDelete;
  final Function()? onTap;
  const EventItem({
    Key? key,
    required this.event,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        event.title,
      ),
      subtitle: Text(
        event.date.toString(),
      ),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}