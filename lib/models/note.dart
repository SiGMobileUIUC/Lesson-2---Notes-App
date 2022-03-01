class Note {
  /// The ID for the note.
  int id;

  /// The title for the note.
  String noteTitle;

  /// The body of the note.
  String note;

  /// The DateTime object of when the note was created.
  DateTime dateTime;

  Note({
    required this.id,
    required this.note,
    required this.noteTitle,
    required this.dateTime,
  });

  factory Note.fromJSON(Map<String, dynamic> json) {
    Note note = Note(
      id: json["id"],
      note: json["note"],
      noteTitle: json["noteTitle"],
      dateTime: DateTime.parse(json["dateTime"]),
    );
    return note;
  }
}
