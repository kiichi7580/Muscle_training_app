import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/login/login_page.dart';
import 'package:provider/provider.dart';
import '../../view_model/signup_model/signup_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final _emailEditingController = TextEditingController();
    final _passwordEditingController = TextEditingController();

    @override
    void dispose() {
      _emailEditingController.dispose();
      _passwordEditingController.dispose();
      super.dispose();
    }

    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新規登録'),
        ),
        backgroundColor: mainColor,
        body: Consumer<SignUpModel>(
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
                            await model.signup();
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (context) {
                                  return const LoginPage();
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
                          '新規登録',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
