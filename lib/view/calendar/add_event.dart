import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muscle_training_app/constant/colors.dart';
import 'package:muscle_training_app/myapp.dart';


class AddEventPage extends StatefulWidget {
  const AddEventPage(
      {super.key,
      required this.firstDate,
      required this.lastDate,
      this.selectedDate,});
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
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('予定を追加')),
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
          Padding(
            padding: const EdgeInsets.all(64),
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
