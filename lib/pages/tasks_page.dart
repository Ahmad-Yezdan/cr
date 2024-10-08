import 'package:cr/db/database_helper.dart';
import 'package:cr/models/task.dart';
import 'package:cr/providers/major_provider.dart';
import 'package:cr/widgets/task_dialog.dart';
import 'package:cr/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final teacherController = TextEditingController();
  final taskController = TextEditingController();
  final deadlineController = TextEditingController();
  final createdDateController = TextEditingController();

  void saveTask() async {
    Provider.of<MajorProvider>(context, listen: false).saveTask(
        Task(
            teacher: teacherController.text,
            task: taskController.text,
            deadline: deadlineController.text,
            createdDate:createdDateController.text),
        context);

    if (!context.mounted) {
      return; //the widget is not mounted don't do anything
    }
  }

  void addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
            isAdding: true,
            teacherController: teacherController,
            taskController: taskController,
            deadlineController: deadlineController,
            createdDateController:createdDateController,
            callback: saveTask);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var provider = Provider.of<MajorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks",
          style: theme.textTheme.headlineMedium,
        ),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: DataBaseHelper.instance.readAllTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  // child: Text("Error: ${snapshot.error}"),
                  child: Text("An error has occured, please try again later."),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Task> savedTasks = snapshot.data!;
                return ListView.builder(
                  itemCount: savedTasks.length,
                  itemBuilder: (context, index) {
                    Task task = savedTasks[index];
                    
                    return TaskCard(
                      task: task,
                      theme: theme,
                      provider: provider,
                      context: context,
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No tasks found."),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
