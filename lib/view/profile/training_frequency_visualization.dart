// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';

Widget buildBody(
  int month,
  List<String> targetMonthDateList,
  List<String> trainingDays,
  List<int> amountOfTraining,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${month}月の筋トレ頻度',
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 24,
          ),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: mainColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(10, 10),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 210,
                width: 270,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 1行に表示する日数
                  ),
                  itemCount: targetMonthDateList.length,
                  itemBuilder: (context, trainingDayIndex) {
                    int index = 0;
                    String targetDate = targetMonthDateList[trainingDayIndex];
                    bool isTrained = trainingDays.contains(targetDate);
                    if (isTrained) {
                      index = trainingDays.indexOf(targetDate);
                    } else {}

                    return Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isTrained
                            ? trainingFrequencyColors[amountOfTraining[index]]
                            : trainingFrequencyColor1, // 日付の背景色
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          // '',
                          // targetMonthDateList[trainingDayIndex],
                          (trainingDayIndex + 1).toString(),
                          style: TextStyle(
                            color: mainColor, // 日付のテキスト色
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 24,
                width: double.infinity,
              ),
              mainFutureExplanation(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget leftButton() {
  return InkWell(
    onTap: () {},
    child: Icon(
      Icons.arrow_left,
      size: 40,
      color: blackColor,
    ),
  );
}

Widget rightButton() {
  return InkWell(
    onTap: () {},
    child: Icon(
      Icons.arrow_right,
      size: 40,
      color: blackColor,
    ),
  );
}

Widget mainFuture(int i, List targetMonthDateList) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (int j = 0; j < 7; j++) ...{
        Container(
          margin: EdgeInsets.all(4),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: trainingFrequencyColors[0],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text('${targetMonthDateList[j]}'),
        ),
      },
    ],
  );
}

Widget mainFutureExplanation() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        '少',
        style: TextStyle(
          fontSize: 14,
          color: blackColor,
        ),
      ),
      SizedBox(
        width: 4,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < 5; i++) ...{
            Container(
              margin: EdgeInsets.all(2),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: trainingFrequencyColors[i],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(''),
            ),
          },
        ],
      ),
      SizedBox(
        width: 4,
      ),
      Text(
        '多',
        style: TextStyle(
          fontSize: 14,
          color: blackColor,
        ),
      ),
      SizedBox(
        width: 50,
      ),
    ],
  );
}
