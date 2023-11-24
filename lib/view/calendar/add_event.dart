import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/rendering.dart';
import 'package:muscle_training_app/view/calendar/event_firestore_service.dart';
import 'package:provider/provider.dart';

import '../../view_model/calendar_model/add_event_model.dart';

class AddEventPage extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
  const AddEventPage(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      this.selectedDate})
      : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventState();
}

class _AddEventState extends State<AddEventPage> {
  late DateTime _selectedDate;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("予定追加")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InputDatePickerFormField(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _selectedDate,
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
          ElevatedButton(
            onPressed: () {
              _addEvent();
            },
            child: const Text("追加する"),
          ),
        ],
      ),
    );
  }

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('予定が入力されていません');
      return;
    }
    await FirebaseFirestore.instance.collection('events').add({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDate),
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}