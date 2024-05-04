import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/profile/beginner_menu/menu/beginner_menu.dart';
import 'package:muscle_training_app/view/profile/beginner_tutorial/beginner_points.dart';

class BeginnerTutorial extends StatefulWidget {
  const BeginnerTutorial({super.key});

  @override
  State<BeginnerTutorial> createState() => _BeginnerTutorialState();
}

class _BeginnerTutorialState extends State<BeginnerTutorial> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;

  List<Widget> list1 = <Widget>[
    const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '初心者が知っておくべきポイント',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: heavyBlueColor,
          ),
        ),
        Icon(
          Icons.expand_more,
          color: heavyBlueColor,
        ),
      ],
    ),
  ];

  List<Widget> list2 = <Widget>[
    const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '初心者におすすめのメニュー',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: heavyBlueColor,
          ),
        ),
        Icon(
          Icons.expand_more,
          color: heavyBlueColor,
        ),
      ],
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
        title: Text(
          '筋トレとは？',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded1 = !_isExpanded1;
                });
                buttonPressed1();
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: greyColor,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                    color: mainColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 24,
                    ),
                    child: Column(
                      children: _items1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: buttonPressed2,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: greyColor,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                    color: mainColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 24,
                    ),
                    child: Column(
                      children: _items2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buttonPressed1() {
    if (_isExpanded1) {
      return list1.add(
        const BeginnerPoints(),
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
        const BeginnerMenu(),
      );
    } else {
      list2.removeLast();
    }
    setState(() {
      _items2 = list2;
    });
  }
}
