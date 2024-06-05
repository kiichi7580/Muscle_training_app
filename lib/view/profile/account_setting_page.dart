import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/profile/beginner_tutorial/beginner_tutorial.dart';
import 'package:muscle_training_app/view/profile/notification/notification_setting_page.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '設定',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          BuildListTile(
            context,
            Icons.fitness_center_rounded,
            '筋トレとは？',
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BeginnerTutorial(),
                ),
              );
            },
          ),
          // const SizedBox(
          //   height: 4,
          // ),
          // BuildListTile(
          //   context,
          //   Icons.menu_book,
          //   'MMについて',
          //   () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const BeginnerTutorial(),
          //       ),
          //     );
          //   },
          // ),
          const SizedBox(
            height: 4,
          ),
          BuildListTile(
            context,
            Icons.notifications,
            '通知',
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationSettingPage(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 4,
          ),
          BuildListTile(
            context,
            Icons.logout,
            'ログアウト',
            () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget BuildListTile(
    BuildContext context,
    IconData icon,
    String title,
    void Function()? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
