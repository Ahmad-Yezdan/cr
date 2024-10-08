class MessageModel {
  int? id;
  final String groups;
  final String message;
  final String time;
  String? createdDate;

  MessageModel(
      {this.id,
      required this.groups,
      required this.message,
      required this.time,
      this.createdDate,});

  // for saving to db
  Map<String, dynamic> toJson() {
    return {
      'groups': groups,
      'message': message,
      'time': time,
      'createdDate':createdDate,
    };
  }

  // for loading from db
  factory MessageModel.fromJsonDatabase(Map<String, dynamic> jsonObject) {
    return MessageModel(
      id: jsonObject['id'] as int,
      groups: jsonObject['groups'] as String,
      message: jsonObject['message'] as String,
      time: jsonObject['time'] as String,
      createdDate:jsonObject['createdDate'] as String,
    );
  }

  @override
  String toString() {
    return "$id provide $message in Group(s):$groups";
  }
}
