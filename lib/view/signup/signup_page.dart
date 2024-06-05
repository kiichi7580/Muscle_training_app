// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/auth_methods.dart';
import 'package:muscle_training_app/resposive/mobile_screen_layout.dart';
import 'package:muscle_training_app/resposive/resposive_layout.dart';
import 'package:muscle_training_app/resposive/web_screen_layout.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/view/login/login_page.dart';
import 'package:muscle_training_app/widgets/text_field_input.dart';

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
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    final userProvider = Provider.of<UserProvider>(context);

    @override
    void dispose() {
      super.dispose();
      _emailController.dispose();
      _passwordController.dispose();
    }

    void navigatorToLogin() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }

    Future<void> signUpUser(
      BuildContext context,
      UserProvider userProvider,
    ) async {
      userProvider.startLoading();
      String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (res == successRes) {
        res = successSignUp;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout:
                  MobileScreenLayout(uid: AuthMethods().getCurrentUserUid()),
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

    Future<void> signUpWithGoogle(
      BuildContext context,
      UserProvider userProvider,
    ) async {
      userProvider.startLoading();
      String res = await AuthMethods().signInWithGoogleAccount();

      if (res == successRes) {
        res = successSignUp;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout:
                  MobileScreenLayout(uid: AuthMethods().getCurrentUserUid()),
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
                prefixIcon: Icon(
                  Icons.email,
                  size: 20,
                  color: blackColor,
                ),
                hintText: 'example@email.com',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                prefixIcon: Icon(
                  Icons.lock,
                  size: 20,
                  color: blackColor,
                ),
                hintText: 'パスワード',
                textInputType: TextInputType.visiblePassword,
                isPass: true,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFieldInput(
                textEditingController: _confirmPasswordController,
                prefixIcon: Icon(
                  Icons.lock,
                  size: 20,
                  color: blackColor,
                ),
                hintText: '確認用パスワード',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              InkWell(
                onTap: () async {
                  String password = _passwordController.text;
                  String confirmPassword = _confirmPasswordController.text;
                  if (password == confirmPassword) {
                    await signUpUser(context, userProvider);
                  } else {
                    String res = wrong_password;
                    showSnackBar(res, context);
                  }
                },
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SignInButton(
                  Buttons.google,
                  text: signInOnGoogle,
                  onPressed: () async {
                    await signUpWithGoogle(context, userProvider);
                  },
                ),
              ),
              Flexible(
                flex: 1,
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
                        'ログイン画面へ',
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
