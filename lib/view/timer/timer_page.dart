import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/timer/add_timer.dart';
import 'package:muscle_training_app/view/timer/display_timer.dart';
import 'package:muscle_training_app/view/timer/edit_timer.dart';
import 'package:muscle_training_app/models/timer_model/timer_model.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerModel>(
      create: (_) => TimerModel()..fetchTimer(),
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'タイマー',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTimerPage(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: Icon(
                Icons.add,
              ),
            ),
          ],
          foregroundColor: blackColor,
          backgroundColor: blueColor,
        ),
        body: Center(
          child: Consumer<TimerModel>(
            builder: (context, model, child) {
              final List<dynamic>? timers = model.timers;

              if (timers == null) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }

              if (timers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.more_time,
                        color: blackColor,
                        size: 45,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'タイマーを追加しましょう',
                        style: TextStyle(
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final List<Widget> widgets = timers.map((timer) {
                return buildBody(context, timer);
              }).toList();
              return ListView(
                children: widgets,
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget buildBody(BuildContext context, dynamic timer) {
  return Slidable(
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (BuildContext context) {
            // 編集画面に遷移
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTimerPage(timer: timer),
              ),
            );
          },
          backgroundColor: blackColor,
          foregroundColor: mainColor,
          icon: Icons.edit,
          label: '編集',
        ),
        SlidableAction(
          onPressed: (context) async {
            final delete = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('削除の確認'),
                content: const Text('予定を削除しますか？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: blackColor,
                    ),
                    child: const Text('いいえ'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(
                      foregroundColor: deleteColor,
                    ),
                    child: const Text('削除'),
                  ),
                ],
              ),
            );
            if (delete ?? false) {
              await FirebaseFirestore.instance
                  .collection('timers')
                  .doc(timer.id)
                  .delete();
            }
          },
          backgroundColor: deleteColor,
          foregroundColor: mainColor,
          icon: Icons.delete,
          label: '削除',
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: const Icon(Icons.alarm_on),
          title: Text(
            timer['timerName'],
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            '${timer['minute']}:${timer['second']}',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.black,
            ),
          ),
          trailing: Icon(
            Icons.arrow_back,
          ),
          dense: true,
          tileColor: mainColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayTimerPage(
                  timerName: timer['timerName'],
                  totalSeconds: timer['totalSeconds'],
                  dynamicSeconds: timer['totalSeconds'],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
