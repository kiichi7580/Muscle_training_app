import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/constant/utils.dart';
import 'package:muscle_training_app/myapp.dart';
import 'package:muscle_training_app/widgets/add_button.dart';

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
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late String color1;
  late String color2;
  late String eventColor;
  String removeWords(String input, List<String> wordsToRemove) {
    String result = input;
    wordsToRemove.forEach((word) {
      result = result.replaceAll(word, '');
    });
    return result;
  }

  List<String> removeStringList = ['MaterialColor(primary value: Color(', ')'];
  late String preColor;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '予定を追加',
          style: TextStyle(
            color: blackColor,
          ),
        ),
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
                          color1 = color.toString();
                          color2 = removeWords(color1, removeStringList);
                          eventColor = color2;
                          print(eventColor);
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
            buttonOnPressed: _addEvent,
          ),
        ],
      ),
    );
  }

  Future<void> _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;

    if (title.isEmpty) {
      String res = '予定が入力されていません。';
      return showSnackbar(res, context);
    }
    if (description.isEmpty) {
      String res = '詳細が入力されていません。';
      return showSnackbar(res, context);
    }
    if (eventColor == '') {
      String res = 'カラーが選択されていません。';
      return showSnackbar(res, context);
    }

    await FirebaseFirestore.instance.collection('events').add({
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(_selectedDate).toDate(),
      'eventColor': eventColor,
    });

    if (mounted) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const Myapp(),
        ),
        (_) => false,
      );
    }
  }
}
