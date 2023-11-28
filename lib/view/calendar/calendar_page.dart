import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/calendar/add_event.dart';
import 'package:muscle_training_app/view/calendar/edit_event.dart';
import 'package:muscle_training_app/view/calendar/event_item.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

import '../../domain/calendar.dart';
import '../../view_model/calendar_model/calendar_model.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  // const CalendarPage(User user, {super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late User user;

  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<void> _loadFirestoreEvents() async {
    print('aaa');
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    // _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: Calendar.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();

    print(snap.docs[0]['title']);

    for (var doc in snap.docs) {
      final event = doc;
      // print(doc['description']);
      // print(event['title']);
      final Timestamp dateEvent = event['date'] as Timestamp;
      final day = (
        dateEvent.toDate().year,
        dateEvent.toDate().month,
        dateEvent.toDate().day,
      );
      print(day);

      _events.putIfAbsent(dateEvent.toDate(), () => []);

      if (_events[dateEvent.toDate()] == null) {
        // print("rarara${_events[dateEvent.toDate()]}");
        _events[dateEvent.toDate()] = [];
      }
      _events[dateEvent.toDate()]!.add(event['title']);
      setState(() {});
      // print(_events[dateEvent.toDate()]);
    }
    print(_events);
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

  List _getEventsForTheDay(DateTime day) {
    // print(_events);
    // print(_events[day]);
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    // _loadFirestoreEvents();

    return Scaffold(
      backgroundColor: mainColor,
      body: ListView(
        children: [
          // Text('{$user}さん、ようこそ！'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: TableCalendar(
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
                  // _loadFirestoreEvents();
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
                    const text = '日';
                    return const Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (day.weekday == DateTime.saturday) {
                    const text = '土';
                    return const Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.blue),
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
                headerStyle: const HeaderStyle(
                  // カレンダーの表示範囲を変えないようにする場合はfalse
                  formatButtonVisible: true,
                  // タイトルを中央にしたかったらこの行を追加
                  titleCentered: true,
                ),
              ),
            ),
          ),
          // ..._getEventsForTheDay(_selectedDay).map(
          //   (event) => EventItem(
          //       event: event,
          //       onTap: () async {
          //         final res = await Navigator.push<bool>(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => EditEventPage(
          //                 firstDate: _firstDay,
          //                 lastDate: _lastDay,
          //                 event: event),
          //           ),
          //         );
          //         if (res ?? false) {
          //           _loadFirestoreEvents();
          //         }
          //       },
          //       onDelete: () async {
          //         final delete = await showDialog<bool>(
          //           context: context,
          //           builder: (_) => AlertDialog(
          //             title: const Text("Delete Event?"),
          //             content: const Text("Are you sure you want to delete?"),
          //             actions: [
          //               TextButton(
          //                 onPressed: () => Navigator.pop(context, false),
          //                 style: TextButton.styleFrom(
          //                   foregroundColor: Colors.black,
          //                 ),
          //                 child: const Text("No"),
          //               ),
          //               TextButton(
          //                 onPressed: () => Navigator.pop(context, true),
          //                 style: TextButton.styleFrom(
          //                   foregroundColor: Colors.red,
          //                 ),
          //                 child: const Text("Yes"),
          //               ),
          //             ],
          //           ),
          //         );
          //         if (delete ?? false) {
          //           await FirebaseFirestore.instance
          //               .collection('events')
          //               .doc(event.id)
          //               .delete();
          //           _loadFirestoreEvents();
          //         }
          //       }),
          // ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: _getEventsForTheDay(_selectedDay).length,
              itemBuilder: (context, index) {
                // _loadFirestoreEvents();
                final event = _getEventsForTheDay(_selectedDay)[index];
                return Card(
                  child: ListTile(
                    title: Text('$event'),
                  ),
                );
              },
            ),
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
            print(result);
            await _loadFirestoreEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
