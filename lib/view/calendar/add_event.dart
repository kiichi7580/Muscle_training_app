import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/myapp.dart';

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
        title: Text(
          '予定を追加',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: mainColor),
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
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: '予定'),
          ),
          TextField(
            controller: _descController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: '詳細'),
          ),
          SizedBox(
            height: 80,
            child: TextButton(
              onPressed: () {
                showDialog(
                  builder: (context) => AlertDialog(
                    title: const Text('色を選択'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: Colors.red,
                        onColorChanged: (color) {
                          // TODO: 変更時処理
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
              child: const Text(
                'カラーを選択する',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                onPressed: _addEvent,
                child: const Text(
                  '追加する',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('予定が入力されていません');
      return;
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
