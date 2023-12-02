import 'package:flutter/material.dart';
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
