import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muscle_training_app/myapp.dart';
import 'package:muscle_training_app/view/drawer/beginner_tutorial.dart';
import 'package:muscle_training_app/view/login/login_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  heavyBlueColor,
                  richBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: CircleAvatar(
                    backgroundColor: mainColor,
                    backgroundImage: AssetImage(
                      'assets/icons/1024 1.png',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
                const Text(
                  'Username',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: Icon(
              Icons.fitness_center_rounded,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              '筋トレとは？',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BeginnerTutorial(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: Icon(
              Icons.menu_book,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'チュートリアル',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              '設定',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'ログアウト',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () async {
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
}
