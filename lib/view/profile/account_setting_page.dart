import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/profile/beginner_tutorial/beginner_tutorial.dart';
import 'package:muscle_training_app/view/login/login_page.dart';
import 'package:muscle_training_app/view/profile/notification/notification_permission_page.dart';

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
          const SizedBox(
            height: 4,
          ),
          BuildListTile(
            context,
            Icons.menu_book,
            'MMについて',
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BeginnerTutorial(),
                ),
              );
            },
          ),
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
                  // builder: (context) => const NotificationSettingPage(),
                  builder: (context) => const NotificationPermissionPage(),
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
              // ログアウト処理
              // 内部で保持しているログイン情報等が初期化される
              // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫）
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginPage();
                  },
                ),
              );
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
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 20,
            ),
      ),
      onTap: onTap,
    );
  }
}
