import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/globalvariavle.dart';

final indexProvider = StateProvider((ref) {
  return 0;
});

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // インデックス
    final index = ref.watch(indexProvider);

    // アイテム
    const items = [
      BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'カレンダー'),
      BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'メモ'),
      BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'タイマー'),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle), label: 'プロフィール'),
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
      // この設定がないとボトムナビゲーターバーの色がつかない
      type: BottomNavigationBarType.fixed,
    );

    final pages = homeScreenItems;

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: bar,
    );
  }
}
