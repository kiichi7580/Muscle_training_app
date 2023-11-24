import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/view/calendar/add_event.dart';
import 'package:muscle_training_app/view/calendar/edit_event.dart';
import 'package:muscle_training_app/view/calendar/event_firestore_service.dart';
import 'package:muscle_training_app/view/calendar/event_item.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

import '../../domain/calendar.dart';
import '../../view_model/calendar_model/calendar_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<Calendar>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadFirestoreEvents();
  }

  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: Calendar.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<Calendar> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('カレンダー')),
      body: ListView(
        children: [
          TableCalendar(
            eventLoader: _getEventsForTheDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _loadFirestoreEvents();
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              print(_events[selectedDay]);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            //日本語化
            locale: 'ja_JP',
            //土・日曜日の色を変える
            calendarBuilders: CalendarBuilders(dowBuilder: (_, day) {
              if (day.weekday == DateTime.sunday) {
                final text = '日';
                return Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (day.weekday == DateTime.saturday) {
                final text = '土';
                return Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.blue),
                  ),
                );
              }
              return null;
            }),
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(
                // 週末の色を指定
                // 土日両方同じ色になってしまうため、改善策を模索中
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
            ),
            headerStyle: HeaderStyle(
              // カレンダーの表示範囲を変えないようにする場合はfalse
              formatButtonVisible: true,
              // タイトルを中央にしたかったらこの行を追加
              titleCentered: true,
            ),
          ),
          ..._getEventsForTheDay(_selectedDay).map(
            (event) => EventItem(
                event: event,
                onTap: () async {
                  final res = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEventPage(
                          firstDate: _firstDay,
                          lastDate: _lastDay,
                          event: event),
                    ),
                  );
                  if (res ?? false) {
                    _loadFirestoreEvents();
                  }
                },
                onDelete: () async {
                  final delete = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete Event?"),
                      content: const Text("Are you sure you want to delete?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                  if (delete ?? false) {
                    await FirebaseFirestore.instance
                        .collection('events')
                        .doc(event.id)
                        .delete();
                    _loadFirestoreEvents();
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventPage(
                firstDate: _firstDay,
                lastDate: _lastDay,
                selectedDate: _selectedDay,
              ),
            ),
          );
          if (result ?? false) {
            _loadFirestoreEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
