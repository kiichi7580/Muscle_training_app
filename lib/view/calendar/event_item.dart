import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/constant/colors.dart';
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
    // 時間フォーマット設定
    DateFormat format = DateFormat('yyyy年M月d日hh時mm分');
    DateTime date1 = event.date;
    String FormatedDate = format.format(date1);

    return Card(
      color: Color(int.parse(event.eventColor)),
      child: ListTile(
        title: Text(
          event.title,
          style: const TextStyle(
            color: mainColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          event.description ?? '',
          style: const TextStyle(
            color: mainColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          color: Colors.white,
          onPressed: onDelete,
        ),
      ),
    );
  }
}
