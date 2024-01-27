import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';

class BeginnerTutorial extends StatefulWidget {
  const BeginnerTutorial({super.key});

  @override
  State<BeginnerTutorial> createState() => _BeginnerTutorialState();
}

class _BeginnerTutorialState extends State<BeginnerTutorial> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;

  List<Widget> list1 = <Widget>[
    Container(
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '◯ 初心者が知っておくべきポイント',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    ),
  ];

  List<Widget> list2 = <Widget>[
    Container(
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '◯ 初心者におすすめのメニュー',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    ),
  ];

  List<Widget> _items1 = <Widget>[];
  List<Widget> _items2 = <Widget>[];

  @override
  void initState() {
    super.initState();
    _items1 = list1;
    _items2 = list2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '筋トレとは？',
          style: TextStyle(
            color: blackColor,
          ),
        ),
        centerTitle: false,
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 16,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: buttonPressed1,
                child: Column(
                  children: _items1,
                ),
              ),
              const SizedBox(
                height: 32,
                width: double.infinity,
              ),
              GestureDetector(
                onTap: buttonPressed2,
                child: Column(
                  children: _items2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buttonPressed1() {
    setState(() {
      _isExpanded1 = !_isExpanded1;
    });
    if (_isExpanded1) {
      return list1.add(
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 10,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
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
                    '　筋トレ前後のストレッチは非常に重要です。筋トレ前には、動的ストレッチを行い、可動域を広げ、体を温めることが望まれます。一方、筋トレ後には、ゆっくりと時間をかけて筋肉や関節を静的に伸ばすことで、疲労回復やリラックスを促進できます。このような適切なストレッチを行うことで、パフォーマンス向上やけがの予防が期待されます。',
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
                    '　筋トレは単にやるだけでなく、鍛えたい目的や部位をしっかり把握することが大切です。たとえば、ヒップアップを目指すならお尻や下半身の筋肉に焦点を当て、バストアップを望むなら胸まわりや上半身の筋肉に意識を向けると効果的です。鍛えたい部分の筋肉を意識しながら筋トレを行うことが効果を高める秘訣です。',
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
                    '　筋トレは過度な負荷でモチベーションを維持できず、挫折の原因になります。だからこそ、自分に少しだけきつい負荷をかけることが大切です。長時間の筋トレは避け、初心者は簡単なメニューで10～20回を3セットほどから始め、1回の筋トレは30分ほどにすると良いでしょう。',
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
                    '　筋トレでは休息が重要です。負荷をかけた筋肉は一部が破壊され、それを休息や睡眠で修復します。筋肉の修復には約48時間かかります。したがって、筋トレ初心者は毎日行うのではなく、週3回ほどからスタートすることがお勧めです。また、同じ部位ばかりでなく、曜日ごとに異なる筋肉を鍛えるスケジュールを組むと良いです。',
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
                    '　筋トレの成果を最大限に引き出すには、栄養バランスのとれた食事が欠かせません。特に、筋肉を回復させるためには、タンパク質（魚・肉・乳製品）の摂取が大切です。また、炭水化物も重要なエネルギー源であり、ダイエットで抜かれがちなので注意が必要です。炭水化物が不足すると、筋肉が分解されエネルギーが不足する可能性があります。ビタミンD（魚介類、きのこ、卵）やビタミンB群（赤身の魚、脂が少ない肉類）も摂取が重要です。これらの栄養素をバランスよく取り入れ、食材を幅広く摂ることが大切です。',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      list1.removeLast();
    }
    setState(() {
      _items1 = list1;
    });
  }

  void buttonPressed2() {
    setState(() {
      _isExpanded2 = !_isExpanded2;
    });
    if (_isExpanded2) {
      return list2.add(
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 10,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '　自宅でも気軽にできるメニューをいくつかご紹介します。',
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
              Column(
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
                    '　胸や腕だけではなく、背中まで鍛えられる筋トレです。',
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
                    '　10回を1セットとして3セット挑戦してみましょう。ツラいと感じるなら、膝を床につけても構いません。',
                    style: TextStyle(fontSize: 18),
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2.クランチ（腹筋）',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '　お腹周りが気になるなら、クランチがおすすめです。',
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
                    '仰向けで、太ももが床と垂直になるよう足を浮かせる',
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
                    '両手を頭の後ろで組み、肩は床から浮かせ、視線はおへそを見る',
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
                    '息を吐きながら、上体を丸め込むイメージで頭を膝に近づける',
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
              ),
              Column(
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
                    '　プランクはお腹周りやお尻を鍛えられるので、プロスポーツ選手や芸能人も取り組んでいることが多い人気メニューです。',
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
              ),
            ],
          ),
        ),
      );
    } else {
      list2.removeLast();
    }
    setState(() {
      _items2 = list2;
    });
  }
}
