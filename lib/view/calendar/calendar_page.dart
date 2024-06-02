import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/calendar/add_event.dart';
import 'package:muscle_training_app/view/calendar/edit_event.dart';
import 'package:muscle_training_app/view/calendar/event_item.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../domain/calendar.dart';
import '../../main_navigation.dart';
import 'widgets/bottom_sheet.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.uid});

  final String uid;

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
  late Map<DateTime, List<Calendar>> _events;
  final DateFormat format = DateFormat('yyyy年MM月dd日');

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Future<void> _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 31);
    // _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        // ここをコメントアウトすれば、他の月の予定も表示されるようになる
        // .where('date', isGreaterThanOrEqualTo: firstDay)
        // .where('date', isLessThanOrEqualTo: lastDay)
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
          fromFirestore: Calendar.fromFirestore,
          toFirestore: (event, options) => event.toFirestore(),
        )
        .get();

    for (final doc in snap.docs) {
      final event = doc;
      final event1 = event.data();

      final Timestamp dateEvent = event['date'] as Timestamp;
      final day = (
        dateEvent.toDate().year,
        dateEvent.toDate().month,
        dateEvent.toDate().day,
      );

      _events.putIfAbsent(dateEvent.toDate(), () => []);

      if (_events[dateEvent.toDate()] == null) {
        _events[dateEvent.toDate()] = [];
      }
      _events[dateEvent.toDate()]!.add(event1);

      setState(() {});
    }
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

  List<Calendar> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    Color _textColor(DateTime day) {
      const _defaultTextColor = Colors.black87;

      if (day.weekday == DateTime.sunday) {
        return Colors.red;
      }
      if (day.weekday == DateTime.saturday) {
        return Colors.blue[600]!;
      }
      return _defaultTextColor;
    }

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'カレンダー',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEventPage(
                    firstDate: _firstDay,
                    lastDate: _lastDay,
                    selectedDate: _selectedDay,
                  ),
                  fullscreenDialog: true,
                ),
              );
              if (result ?? false) {
                await _loadFirestoreEvents();
              }
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              elevation: 4,
              color: mainColor,
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
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                //日本語化
                locale: 'ja_JP',
                //土・日曜日の色を変える
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (
                    BuildContext context,
                    DateTime day,
                    DateTime focusedDay,
                  ) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      // margin: EdgeInsets.zero,
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: Colors.blueAccent,
                      //     width: 0.5,
                      //   ),
                      // ),
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: _textColor(day),
                        ),
                      ),
                    );
                  },
                  dowBuilder: (_, day) {
                    if (day.weekday == DateTime.sunday) {
                      const text = '日';
                      return const Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      );
                    } else if (day.weekday == DateTime.saturday) {
                      const text = '土';
                      return const Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                calendarStyle: CalendarStyle(
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
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
                      event: event,
                      uid: widget.uid,
                    ),
                  ),
                );
                if (res ?? false) {
                  await _loadFirestoreEvents();
                }
              },
              onDelete: () async {
                final delete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('削除の確認'),
                    content: const Text('予定を削除しますか？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          foregroundColor: blackColor,
                        ),
                        child: const Text('いいえ'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: deleteColor,
                        ),
                        child: const Text('削除'),
                      ),
                    ],
                  ),
                );
                if (delete ?? false) {
                  await FirebaseFirestore.instance
                      .collection('events')
                      .doc(event.id)
                      .delete();
                  await Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => MainNavigation(uid: widget.uid),
                    ),
                    (_) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: '1',
        tooltip: 'メニューを表示する',
        onPressed: () {
          final String formattedDate = format.format(_selectedDay).toString();

          BottomSheetWidget(
            context,
            date: formattedDate,
          );
        },
        backgroundColor: addFloationActionButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.fitness_center,
        ),
      ),
    );
  }
}
