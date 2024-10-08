import 'package:cr/models/task.dart';
import 'package:cr/notifications/notification_helper.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class TaskDialog extends StatelessWidget {
  final bool isAdding;
  final TextEditingController teacherController;
  final TextEditingController taskController;
  final TextEditingController deadlineController;
  final TextEditingController? createdDateController;
  final Task? task;

  final VoidCallback callback;
  const TaskDialog(
      {super.key,
      required this.isAdding,
      this.task,
      required this.teacherController,
      required this.taskController,
      required this.deadlineController,
      this.createdDateController,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Text(isAdding ? "Add Task" : "Edit Task"),
      content: Form(
        key: formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: !isAdding ? task!.teacher : "",
              decoration: const InputDecoration(
                labelText: "Teacher Name",
                isDense: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Teacher name is required";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                teacherController.text = newValue!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: null,
              initialValue: !isAdding ? task!.task : "",
              decoration: const InputDecoration(
                labelText: "Task",
                isDense: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Task is required";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                taskController.text = newValue!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // TextFormField(
            //   initialValue: !isAdding ? task!.deadline : "",
            //   decoration: const InputDecoration(
            //     labelText: "Deadline",
            //     isDense: true,
            //     border: OutlineInputBorder(),
            //   ),
            //   validator: (value) {
            //     if (value.toString().isEmpty) {
            //       return "Deadline is required";
            //     } else {
            //       return null;
            //     }
            //   },
            //   onSaved: (newValue) {
            //     deadlineController.text = newValue!;
            //   },
            // ),
            DateTimePicker(
              initialValue: !isAdding ? task!.deadline : "",
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 120)),
              // dateLabelText: 'Deadline',
              decoration: const InputDecoration(
                labelText: "Deadline",
                isDense: true,
                border: OutlineInputBorder(),
              ),
              type: DateTimePickerType.dateTime,
              // onChanged: (val) => print(val),
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Deadline is required";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                deadlineController.text = newValue!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        String currentTimeStamp = DateTime.now().toString();
                        createdDateController?.text = currentTimeStamp;
                        callback();
                        if (isAdding) {
                          NotificationHelper.periodicNotification(
                              id: currentTimeStamp.hashCode,
                              title: teacherController.text,
                              body: taskController.text);
                          
                        } else {
                            NotificationHelper.periodicNotification(
                              id: task!.createdDate.hashCode,
                              title: teacherController.text,
                              body: taskController.text);
                        }
                      Navigator.pop(context);
                        // print("Teacher :" + teacherController.text);
                      }
                    },
                    child: Text(isAdding ? "Save" : "Done")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
