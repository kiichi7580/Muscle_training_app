import 'package:flutter/cupertino.dart';
import 'package:muscle_training_app/constant/colors.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.buttonText,
    required this.buttonOnPressed,
  });

  final String buttonText;
  final Function() buttonOnPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 200,
      child: CupertinoButton(
        color: blueColor,
        onPressed: buttonOnPressed,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
