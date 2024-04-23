import 'package:flutter/cupertino.dart';

class Menu1 extends StatelessWidget {
  const Menu1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1.プッシュアップ（腕立て伏せ）',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                ' 胸や腕だけではなく、背中まで鍛えられる筋トレです。',
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
                'うつ伏せになり、肩の高さに手首が来るように手を床に置く',
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
                '頭からかかとまで体を浮かせて、一直線にキープ',
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
                '肘を曲げながら体をゆっくりと下げる',
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
                'ゆっくりと肘を伸ばして体を上げる',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                ' 10回を1セットとして3セット挑戦してみましょう。ツラいと感じるなら、膝を床につけても構いません。',
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
                '・鍛えたい部位を意識する',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '・ゆっくり上下させて筋肉に負荷をかける',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '・正しいフォームが最優先',
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