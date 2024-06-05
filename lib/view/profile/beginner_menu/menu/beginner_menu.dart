// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:muscle_training_app/view/profile/beginner_menu/menu/menu_1.dart';
import 'package:muscle_training_app/view/profile/beginner_menu/menu/menu_2.dart';
import 'package:muscle_training_app/view/profile/beginner_menu/menu/menu_3.dart';
import 'package:muscle_training_app/view/profile/beginner_menu/menu/menu_4.dart';
import 'package:muscle_training_app/view/profile/beginner_menu/menu/menu_5.dart';
import 'package:muscle_training_app/view/profile/beginner_menu/menu/menu_6.dart';
import 'package:muscle_training_app/view/profile/beginner_menu/menu/menu_7.dart';

class BeginnerMenu extends StatelessWidget {
  const BeginnerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 12,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
          ),
          Text(
            ' 自宅でも気軽にできるメニューをいくつかご紹介します。',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            '1.プッシュアップ（腕立て伏せ）',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            '2.クランチ（腹筋）',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            '3.プランク（フロントブリッジ）',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            '4.ヒップリフト',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            '5.スクワット',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            '6.レッグランジ',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            '7.リバースエルボープッシュアップ',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Menu1(),
          Menu2(),
          Menu3(),
          Menu4(),
          Menu5(),
          Menu6(),
          Menu7(),
        ],
      ),
    );
  }
}
