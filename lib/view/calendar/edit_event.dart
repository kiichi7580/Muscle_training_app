import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:muscle_training_app/domain/calendar.dart';

import '../../myapp.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.event,
  });
  final DateTime firstDate;
  final DateTime lastDate;
  final Calendar event;

  @override
  State<EditEventPage> createState() => _EditEventState();
}

class _EditEventState extends State<EditEventPage> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;

  late String color1;
  late String color2;
  late String color3;
  late String eventColor;
  String removeWords(String input, List<String> wordsToRemove) {
    String result = input;
    wordsToRemove.forEach((word) {
      result = result.replaceAll(word, '');
    });
    return result;
  }

  List<String> removeStringList = ['MaterialColor(primary value: Color(', ')'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
    eventColor = widget.event.eventColor;
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
      appBar: AppBar(title: const Text('予定を編集')),
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
                          color3 = color2;
                          eventColor = color3;
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
            padding: const EdgeInsets.all(64),
            child: SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                onPressed: _addEvent,
                child: const Text(
                  '変更する',
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

    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(_selectedDate).toDate(),
      'eventColor': eventColor
    });
    if (mounted) {
      // Navigator.pop<bool>(context, true);
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
