import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view/calendar/calendar_page.dart';
import 'view/memo/memo_page.dart';
import 'view/timer/timer_page.dart';


// プロバイダー
final indexProvider = StateProvider((ref) {
  // 変化させたいデータ
  return 0;
});

class Myapp extends ConsumerWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // インデックス
    final index = ref.watch(indexProvider);

    // アイテム
    const items = [
      BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'カレンダー'),
      BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'メモ'),
      BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'タイマー'),
    ];

    final bar = BottomNavigationBar(
      items: items,
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black45,
      currentIndex: index,
      onTap: (index) {
        ref.read(indexProvider.notifier).state = index;
      },
    );

    final pages = [
      CalendarPage(),
      MemoPage(),
      TimerPage(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: bar,
    );

  }
}

