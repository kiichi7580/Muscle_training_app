// Flutter imports:
import 'package:flutter/cupertino.dart';

class Menu3 extends StatelessWidget {
  const Menu3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3.プランク（フロントブリッジ）',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          ' プランクはお腹周りやお尻を鍛えられるので、プロスポーツ選手や芸能人も取り組んでいることが多い人気メニューです。',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          '〈やり方〉',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          '(STEP1)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'うつ伏せにして腕を肩幅程度に広げ、肘をついて上体を起こす',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '(STEP2)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'つま先を立てて下半身を浮かせる',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '(STEP3)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '足から首筋までが一直線になった状態をキープ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '(STEP4)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '息を吸いながら、ゆっくりと元の位置に戻す',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          ' 3の状態を30秒ほどキープし、休憩を30秒はさみます。（これで1セット）まずは3セット挑戦してみてください。',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          '〈トレーニングのコツ〉',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          '・勢いや反動を使わない',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '・肘は固定させる',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '・下げるときはゆっくりと',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 32,
        ),
      ],
    );
  }
}
