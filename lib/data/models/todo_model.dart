class Todo {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isDone;

  const Todo({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isDone,
  });

  Todo copy({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isDone,
  }) =>
      Todo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        isDone: isDone ?? this.isDone,
      );

  static Todo fromJson(Map<String, Object?> json) => Todo(
        id: json[TodoFields.id] as int?,
        title: json[TodoFields.title] as String,
        description: json[TodoFields.description] as String,
        dueDate: DateTime.parse(json[TodoFields.dueDate] as String),
        isDone: (json[TodoFields.isDone] as int) == 1,
      );

  Map<String, Object?> toJson() => {
        TodoFields.id: id,
        TodoFields.title: title,
        TodoFields.description: description,
        TodoFields.dueDate: dueDate.toIso8601String(),
        TodoFields.isDone: isDone ? 1 : 0,
      };
}

class TodoFields {
  static final List<String> values = [id, title, description, dueDate, isDone];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String dueDate = 'dueDate';
  static const String isDone = 'isDone';
}
