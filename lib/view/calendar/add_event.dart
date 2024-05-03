import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/text_resorce.dart';
import 'package:muscle_training_app/domain/user.dart';
import 'package:muscle_training_app/providers/user_provider.dart';
import 'package:muscle_training_app/resources/calendar_firestore_methods.dart';
import 'package:muscle_training_app/myapp.dart';
import 'package:muscle_training_app/widgets/add_button.dart';
import 'package:muscle_training_app/util/show_snackbar.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.selectedDate,
  });
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;

  @override
  State<AddEventPage> createState() => _AddEventState();
}

class _AddEventState extends State<AddEventPage> {
  late DateTime _selectedDate;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late String eventColor;
  late DateTime setDate;

  bool _isLoading = false;

  Future<void> addCalendar(
    BuildContext context,
    String title,
    String description,
    String eventColor,
    DateTime date,
    String uid,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await CalendarFireStoreMethods().addCalendar(
        title,
        description,
        eventColor,
        date,
        uid,
      );
      if (res == successRes) {
        res = successAdd;
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    print('user: $user');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '予定を追加',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () async {},
        //     child: Text(
        //       saveTx,
        //       style: TextStyle(
        //         color: blackColor,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ],
        foregroundColor: blackColor,
        backgroundColor: blueColor,
      ),
      backgroundColor: mainColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InputDatePickerFormField(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _selectedDate,
            fieldLabelText: '日付',
            onDateSubmitted: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: '予定'),
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _descController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: '詳細'),
          ),
          SizedBox(
            height: 80,
            child: TextButton.icon(
              onPressed: () {
                showDialog(
                  builder: (context) => AlertDialog(
                    title: const Text('色を選択'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: Colors.red,
                        onColorChanged: (color) {
                          eventColor = color.toString();
                        },
                      ),
                    ),
                  ),
                  context: context,
                );
              },
              icon: const Icon(
                Icons.color_lens,
              ),
              label: const Text(
                'カラーを選択する',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          AddButton(
            buttonText: '追加する',
            buttonOnPressed: () async {
              await addCalendar(
                context,
                _titleController.text,
                _descController.text,
                eventColor,
                _selectedDate,
                user.uid,
              );
              if (mounted) {
                await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const Myapp(),
                  ),
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
