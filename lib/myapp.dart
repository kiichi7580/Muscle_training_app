import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/widgets/main_drawer.dart';
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
      backgroundColor: blueColor,
      selectedItemColor: mainColor,
      unselectedItemColor: blackColor,
      currentIndex: index,
      onTap: (index) {
        ref.read(indexProvider.notifier).state = index;
      },
    );

    final pages = [
      const CalendarPage(),
      const MemoPage(),
      const TimerPage(),
    ];

    final titles = [
      'カレンダー',
      'メモ',
      'タイマー',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        // Drawerのアイコンの色を変える方法
        iconTheme: const IconThemeData(color: blackColor),
        title: Text(
          titles[index],
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: blackColor,
              ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () {
        //       if (index == 0) {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => const AddMemoPage(),
        //             fullscreenDialog: true,
        //           ),
        //         );
        //       }
        //       if (index == 1) {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => const AddMemoPage(),
        //             fullscreenDialog: true,
        //           ),
        //         );
        //       }
        //       if (index == 2) {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => const AddTimerPage(),
        //             fullscreenDialog: true,
        //           ),
        //         );
        //       }
        //     },
        //   ),
        // ],
      ),
      drawer: const MainDrawer(),
      body: pages[index],
      bottomNavigationBar: bar,
    );
  }
}
