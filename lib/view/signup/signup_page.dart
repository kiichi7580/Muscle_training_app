import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/widgets/show_snackbar.dart';
import 'package:muscle_training_app/resources/auth_methods.dart';
import 'package:muscle_training_app/resposive/mobile_screen_layout.dart';
import 'package:muscle_training_app/resposive/resposive_layout.dart';
import 'package:muscle_training_app/resposive/web_screen_layout.dart';
import 'package:muscle_training_app/view/login/login_page.dart';
import 'package:muscle_training_app/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final userProvider = Provider.of<UserProvider>(context);

    @override
    void dispose() {
      super.dispose();
      _emailController.dispose();
      _passwordController.dispose();
    }

    void navigatorToLogin() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }

    void signUpUser(
      BuildContext context,
      UserProvider userProvider,
    ) async {
      userProvider.startLoading();
      String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (res == 'success') {
        res = '新規登録に成功しました。';
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          ),
        );
        userProvider.endLoading();
        showSnackBar(res, context);
      } else {
        showSnackBar(res, context);
      }
      userProvider.endLoading();
    }

    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Image.asset(
                '/Users/nakasatokiichi/StudioProjects/Muscle_training_app/assets/icons/1024.png',
                height: 104,
              ),
              const SizedBox(
                height: 16,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MM',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'に新規登録',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'example@email.com',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'パスワード',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () => signUpUser(
                  context,
                  userProvider,
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: heavyBlueColor,
                  ),
                  child: userProvider.getLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        )
                      : const Text(
                          '新規登録',
                          style: TextStyle(
                            color: mainColor,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text(
                      'すでにアカウントをお持ちの方はこちら',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: navigatorToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        'ログイン',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: linkBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
