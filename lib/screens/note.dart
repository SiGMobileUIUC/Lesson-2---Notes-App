import 'package:flutter/material.dart';
import 'package:notes_app/misc/colors.dart';

class Note extends StatefulWidget {
  final String title;
  final String note;

  const Note({Key? key, this.title = "", this.note = ""}) : super(key: key);

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.title.isNotEmpty) {
      _titleController.text = widget.title;
    }
    if (widget.note.isNotEmpty) {
      _noteController.text = widget.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: "Title",
            hintStyle: TextStyle(
              fontSize: 30.0,
            ),
          ),
          style: const TextStyle(fontSize: 30.0),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        height: double.infinity,
        child: TextField(
          controller: _noteController,
          autofocus: true,
          cursorColor: AppColors.urbanaOrange,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
