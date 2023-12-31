import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/signup/signup_page.dart';
import 'package:provider/provider.dart';
import '../../myapp.dart';
import '../../view_model/login_model/login_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _emailEditingController = TextEditingController();
    final _passwordEditingController = TextEditingController();

    @override
    void dispose() {
      _emailEditingController;
      _passwordEditingController;
      super.dispose();
    }

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ログイン'),
          //   leading: IconButton(
          //       onPressed: () {
          //         Navigator.of(context).pushReplacement(
          //           MaterialPageRoute<void>(
          //             builder: (context) => const Myapp(),
          //           ),
          //         );
          //       },
          //       icon: const Icon(Icons.arrow_back_ios),),
        ),
        backgroundColor: mainColor,
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailEditingController,
                      decoration:
                          const InputDecoration(hintText: 'example@email.com'),
                      onChanged: (text) {
                        model.email = text;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _passwordEditingController,
                      decoration: const InputDecoration(hintText: 'パスワード'),
                      obscureText: true,
                      onChanged: (text) {
                        model.password = text;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
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
                              MaterialPageRoute<void>(
                                builder: (context) {
                                  return const Myapp();
                                },
                              ),
                            );
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
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
                      padding: const EdgeInsets.all(8),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
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
          },
        ),
      ),
    );
  }
}
