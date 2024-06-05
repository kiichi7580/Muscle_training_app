// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/auth_methods.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/view/login/login_page.dart';

class EmailConfirmationPage extends StatefulWidget {
  const EmailConfirmationPage({
    super.key,
    required this.targetEmail,
  });
  final String targetEmail;

  @override
  _EmailConfirmationPageState createState() => _EmailConfirmationPageState();
}

class _EmailConfirmationPageState extends State<EmailConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    void navigatorToLogin() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }

    Future<void> resetPasswordForm(
      BuildContext context,
      UserProvider userProvider,
    ) async {
      userProvider.startLoading();
      String res = await AuthMethods().resetPasswordForm(
        targetEmail: widget.targetEmail,
      );

      if (res == successRes) {
        res = successResendEmail;
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
                flex: 1,
                child: Container(),
              ),
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      color: lightGreenColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: mediumGreenColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: darkGreenColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 40,
                    child: Icon(
                      Icons.email,
                      size: 80,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'メールを確認してください',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: blackColor,
                  ),
                  children: [
                    TextSpan(
                      text: '${widget.targetEmail}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          '宛に、パスワード再設定手続きのためのメールを送信いたしました。お手続きを完了していただくことで、新しいパスワードを設定できます。',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () async {
                  await resetPasswordForm(context, userProvider);
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
                      ? const CircularProgressIndicator(
                          color: mainColor,
                        )
                      : const Text(
                          'メールを再送信',
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              InkWell(
                onTap: navigatorToLogin,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: heavyBlueColor,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: mainColor,
                  ),
                  child: userProvider.getLoading
                      ? const CircularProgressIndicator(
                          color: heavyBlueColor,
                        )
                      : const Text(
                          'ログイン画面に戻る',
                          style: TextStyle(
                            color: heavyBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
