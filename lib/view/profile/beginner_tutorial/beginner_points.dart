// Flutter imports:
import 'package:flutter/cupertino.dart';

class BeginnerPoints extends StatelessWidget {
  const BeginnerPoints({super.key});

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '①筋トレ前後にストレッチをする',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' 筋トレ前後のストレッチは非常に重要です。筋トレ前には、動的ストレッチを行い、可動域を広げ、体を温めることが望まれます。一方、筋トレ後には、ゆっくりと時間をかけて筋肉や関節を静的に伸ばすことで、疲労回復やリラックスを促進できます。このような適切なストレッチを行うことで、パフォーマンス向上やけがの予防が期待されます。',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '②鍛える目的や部位を把握する',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' 筋トレは単にやるだけでなく、鍛えたい目的や部位をしっかり把握することが大切です。たとえば、ヒップアップを目指すならお尻や下半身の筋肉に焦点を当て、バストアップを望むなら胸まわりや上半身の筋肉に意識を向けると効果的です。鍛えたい部分の筋肉を意識しながら筋トレを行うことが効果を高める秘訣です。',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '③負荷をかけすぎないようにする',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' 筋トレは過度な負荷でモチベーションを維持できず、挫折の原因になります。だからこそ、自分に少しだけきつい負荷をかけることが大切です。長時間の筋トレは避け、初心者は簡単なメニューで10～20回を3セットほどから始め、1回の筋トレは30分ほどにすると良いでしょう。',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '④筋肉を休ませる',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' 筋トレでは休息が重要です。負荷をかけた筋肉は一部が破壊され、それを休息や睡眠で修復します。筋肉の修復には約48時間かかります。したがって、筋トレ初心者は毎日行うのではなく、週3回ほどからスタートすることがお勧めです。また、同じ部位ばかりでなく、曜日ごとに異なる筋肉を鍛えるスケジュールを組むと良いです。',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⑤バランスの良い食事を摂る',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ' 筋トレの成果を最大限に引き出すには、栄養バランスのとれた食事が欠かせません。特に、筋肉を回復させるためには、タンパク質（魚・肉・乳製品）の摂取が大切です。また、炭水化物も重要なエネルギー源であり、ダイエットで抜かれがちなので注意が必要です。炭水化物が不足すると、筋肉が分解されエネルギーが不足する可能性があります。ビタミンD（魚介類、きのこ、卵）やビタミンB群（赤身の魚、脂が少ない肉類）も摂取が重要です。これらの栄養素をバランスよく取り入れ、食材を幅広く摂ることが大切です。',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
