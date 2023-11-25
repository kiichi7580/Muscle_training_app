import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/rendering.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/domain/memo.dart';
import 'package:muscle_training_app/view/signup/signup_page.dart';
import 'package:muscle_training_app/view_model/memo_model/memo_model.dart';
import 'package:provider/provider.dart';
import 'package:muscle_training_app/view_model/memo_model/add_memo_model.dart';
import 'package:muscle_training_app/view/memo/table_memo.dart';

import '../../app.dart';
import '../../view_model/login_model/login_model.dart';
import '../../view_model/signup_model/signup_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emailEditingController = TextEditingController();
    final passwordEditingController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ログイン'),
        ),
        backgroundColor: mainColor,
        body: Consumer<LoginModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailEditingController,
                    decoration:
                        const InputDecoration(hintText: 'example@email.com'),
                    onChanged: (text) {
                      model.email = text;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: passwordEditingController,
                    decoration: const InputDecoration(hintText: 'パスワード'),
                    obscureText: true,
                    onChanged: (text) {
                      model.password = text;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () async {
                        //追加の処理
                        try {
                          await model.login();
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return Myapp();
                            }),
                          );
                        } catch (e) {
                          print(e);
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text(
                        'ログイン',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ));
                      },
                      child: const Text(
                        '新規登録はこちら',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
