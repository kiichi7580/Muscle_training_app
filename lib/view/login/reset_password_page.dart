import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/auth_methods.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:muscle_training_app/view/login/email_confirmation_page.dart';
import 'package:muscle_training_app/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final userProvider = Provider.of<UserProvider>(context);

    @override
    void dispose() {
      super.dispose();
      _emailController.dispose();
    }

    void navigatorToLogin() {
      Navigator.of(context).pop();
    }

    Future<void> resetPasswordForm(
      BuildContext context,
      UserProvider userProvider,
    ) async {
      userProvider.startLoading();
      String res = await AuthMethods().resetPasswordForm(
        targetEmail: _emailController.text,
      );

      if (res == successRes) {
        res = successResendEmail;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EmailConfirmationPage(
              targetEmail: _emailController.text,
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
                flex: 1,
                child: Container(),
              ),
              Image.asset(
                '/Users/nakasatokiichi/StudioProjects/Muscle_training_app/assets/icons/1024.png',
                height: 104,
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Text(
                'パスワード再設定メールを送信',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 80,
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
              SizedBox(
                height: 32,
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
                          'メールを送信',
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              GestureDetector(
                onTap: navigatorToLogin,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: const Text(
                    'ログインページに戻る',
                    style: TextStyle(
                      fontSize: 18,
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
        ),
      ),
    );
  }
}
