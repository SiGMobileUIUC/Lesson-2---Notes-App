import 'package:flutter/material.dart';
import 'package:notes_app/misc/colors.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/database_service.dart';

class Notes extends StatefulWidget {
  final Note note;

  const Notes({Key? key, required this.note}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  FocusNode noteFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.note.noteTitle.isNotEmpty) {
      _titleController.text = widget.note.noteTitle;
    }
    if (widget.note.note.isNotEmpty) {
      _noteController.text = widget.note.note;
    }
    titleFocusNode.addListener(() async {
      if (!titleFocusNode.hasFocus) {
        await updateTitle();
      }
    });
    noteFocusNode.addListener(() async {
      if (!noteFocusNode.hasFocus) {
        await updateNote();
      }
    });
  }

  Future<void> updateNote() async {
    widget.note.note = _noteController.text;
    await DBService.db.editNote(widget.note);
  }

  Future<void> updateTitle() async {
    widget.note.noteTitle = _titleController.text;
    await DBService.db.editNote(widget.note);
  }

  @override
  void dispose() {
    super.dispose();
    titleFocusNode.dispose();
    noteFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await updateNote();
            await updateTitle();
            Navigator.of(context).pop();
          },
        ),
        title: TextField(
          focusNode: titleFocusNode,
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
          maxLines: null,
          focusNode: noteFocusNode,
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
