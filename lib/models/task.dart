class Task {
  int? id;
  final String teacher;
  final String task;
  final String deadline;
  String? createdDate;

  Task(
      {this.id,
      required this.teacher,
      required this.task,
      required this.deadline,
      this.createdDate,
      });

  // for saving to db
  Map<String, dynamic> toJson() {
    return {
      'teacher': teacher,
      'task': task,
      'deadline': deadline,
      'createdDate':createdDate,
    };
  }

  // for loading from db
  factory Task.fromJsonDatabase(Map<String, dynamic> jsonObject) {
    return Task(
      id: jsonObject['id'] as int,
      teacher: jsonObject['teacher'] as String,
      task: jsonObject['task'] as String,
      deadline: jsonObject['deadline'] as String,
      createdDate:jsonObject['createdDate'] as String,
    );
  }

  @override
  String toString() {
    return "$id $teacher has given task:$task";
  }
}
