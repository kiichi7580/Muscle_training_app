// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/view/calendar/widgets/menu_widget.dart';

void BottomSheetWidget(BuildContext context, {required String date}) async {
  final result = await showBarModalBottomSheet<dynamic>(
    context: context,
    builder: (context) => _buildBottomSheetContent(
      date: date,
    ),
  );
  print(result);
}

class _buildBottomSheetContent extends StatefulWidget {
  const _buildBottomSheetContent({Key? key, required this.date})
      : super(key: key);
  final String date;

  @override
  State<_buildBottomSheetContent> createState() =>
      _buildBottomSheetContentState();
}

class _buildBottomSheetContentState extends State<_buildBottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 8,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.date}のメニュー',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: 0,
                  maxHeight: 670,
                ),
                child: MenuWidget(
                  context,
                  widget.date,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
