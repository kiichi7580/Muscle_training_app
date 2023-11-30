import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/domain/calendar.dart';

class EditEventPage extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Calendar event;
  const EditEventPage(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.event})
      : super(key: key);

  @override
  State<EditEventPage> createState() => _EditEventState();
}

class _EditEventState extends State<EditEventPage> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
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
              print(date);
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
          Padding(
            padding: const EdgeInsets.all(64),
            child: SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  _addEvent();
                },
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

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('title cannot be empty');
      return;
    }
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .update({
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(_selectedDate).toDate(),
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
