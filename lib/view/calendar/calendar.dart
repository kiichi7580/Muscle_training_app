import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List> _eventsList = {};

  DateTime _focused = DateTime.now();
  DateTime? _selected;



  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();

    _selected = _focused;
    _eventsList = {
      DateTime.now().subtract(Duration(days: 2)): ['Test A', 'Test B'],
      DateTime.now(): ['Test C', 'Test D', 'Test E', 'Test F'],
    };
  }

  @override
  Widget build(BuildContext context) {

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEvent(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
      ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2022, 4, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              eventLoader: getEvent,
              //日本語化してる↓↓
              locale: 'ja_JP',
              selectedDayPredicate: (day) {
                return isSameDay(_selected, day);
              },
              onDaySelected: (selected, focused) {
                if (!isSameDay(_selected, selected)) {
                  setState(() {
                    _selected = selected;
                    _focused = focused;
                  });
                }
              },
              focusedDay: _focused,
              //日曜日の色を変える↓↓
        // calendarBuilders: CalendarBuilders(
        // dowBuilder: (_, day) {
        //   if (day.weekday == DateTime.sunday) {
        //     final text = DateFormat.E().format(day);
        //     return Center(
        //       child: Text(
        //         text,
        //         style: const TextStyle(color: Colors.red),
        //       ),
        //     );
        //   }
        //   return null;
        // }
        // ),
            ),
            ListView(
              shrinkWrap: true,
              children: getEvent(_selected!)
                  .map((event) => ListTile(
                title: Text(event.toString()),
              ))
                  .toList(),
            ),
          ],
        ),
      );
  }
}

