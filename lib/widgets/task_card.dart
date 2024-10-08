import 'package:cr/models/task.dart';
import 'package:cr/notifications/notification_helper.dart';
import 'package:cr/providers/major_provider.dart';
import 'package:cr/widgets/task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TaskCard extends StatelessWidget {
  TaskCard({
    super.key,
    required this.task,
    required this.theme,
    required this.provider,
    required this.context,
  });

  final Task task;
  final ThemeData theme;
  final MajorProvider provider;
  final BuildContext context;

  var teacherController = TextEditingController();
  var taskController = TextEditingController();
  var deadlineController = TextEditingController();

  void update() async {
    Provider.of<MajorProvider>(context, listen: false).updateTask(
        Task(
            id: task.id,
            teacher: teacherController.text,
            task: taskController.text,
            deadline: deadlineController.text),
        context);

    if (!context.mounted) {
      return; //the widget is not mounted don't do anything
    }
  }

  void showUpdateTask() {
    showDialog(
      context: context,
      builder: (context) {
        return TaskDialog(
            isAdding: false,
            teacherController: teacherController,
            taskController: taskController,
            deadlineController: deadlineController,
            task: task,
            callback: update);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            task.teacher,
            style: theme.textTheme.titleLarge,
          ),
          subtitle: Text(
            "Deadline: ${DateFormat.yMd().add_jm().format(DateTime.parse(task.deadline))}",
            style: theme.textTheme.titleSmall,
          ),
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              // alignment: Alignment.topLeft,
              // color: Colors.black,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                          TextSpan(
                              text: "Task: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          TextSpan(text: task.task),
                        ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: showUpdateTask,
                            child: const Text("Edit")),
                        TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Have You completed this task?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () {
                                            provider.deleteTask(
                                                task.id!, context);
                                            NotificationHelper.cancel(
                                                id: task.createdDate!.hashCode);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yes")),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text("Mark as completed")),
                      ],
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
