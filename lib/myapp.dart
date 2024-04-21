import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/globalvariavle.dart';

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

    final pages = homeScreenItems;

    return Scaffold(
    //   drawer: const MainDrawer(),
      body: pages[index],
      bottomNavigationBar: bar,
    );
  }
}
