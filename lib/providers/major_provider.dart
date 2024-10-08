import 'package:cr/db/database_helper.dart';
import 'package:cr/models/message_model.dart';
import 'package:cr/models/task.dart';
import 'package:cr/pages/tasks_page.dart';
import 'package:cr/pages/updates_page.dart';
import 'package:flutter/material.dart';

class MajorProvider with ChangeNotifier {
  late int _currentIndex;

  MajorProvider() {
    _currentIndex = 0;
  }

  final List<Widget> _screens = [
    const TaskScreen(),
    const MessageScreen(),
  ];

  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Widget loadScreen() {
    return _screens[_currentIndex];
  }

  //insert task to database
  Future<void> saveTask(Task task, BuildContext context) async {
    try {
      await DataBaseHelper.instance.insertTask(task);
      showSnackBar(context: context, message: "Task added.");
      notifyListeners();
    } catch (e) {
      // print("Error: $e");
    }
  }


  //upadte task in database
  Future<void> updateTask(Task task, BuildContext context) async {
    try {
      await DataBaseHelper.instance.updateTask(task);
      showSnackBar(context: context, message: "Task updated.");
      notifyListeners();
    } catch (e) {
      // print("Error: $e");
    }
  }


  //deleting task from database
  Future<void> deleteTask(int id, BuildContext context) async {
    try {
      await DataBaseHelper.instance.deleteTask(id);
      showSnackBar(context: context, message: "Task Completed.");
      notifyListeners();
    } catch (e) {
      // print("Error: $e");
    }
  }

  //insert message to database
  Future<void> saveMessage(MessageModel messsage, BuildContext context) async {
    try {
      await DataBaseHelper.instance.insertMessage(messsage);
      showSnackBar(context: context, message: "Message added.");
      notifyListeners();
    } catch (e) {
      // print("Error: $e");
    }
  }


  //upadte message in database
  Future<void> updateMessage(MessageModel messsage, BuildContext context) async {
    try {
      await DataBaseHelper.instance.updateMessage(messsage);
      showSnackBar(context: context, message: "Message updated.");
      notifyListeners();
    } catch (e) {
      // print("Error: $e");
    }
  }


  //deleting message from database
  Future<void> deleteMessage(int id, BuildContext context) async {
    try {
      await DataBaseHelper.instance.deleteMessage(id);
      showSnackBar(context: context, message: "Message delivered.");
      notifyListeners();
    } catch (e) {
      // print("Error: $e");
    }
  }

}

void showSnackBar({required BuildContext context, required String message}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 1),
    margin: const EdgeInsets.all(30),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
