import 'package:cr/models/message_model.dart';
import 'package:cr/notifications/notification_helper.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final bool isAdding;
  final TextEditingController groupController;
  final TextEditingController messageController;
  final TextEditingController timeController;
  final TextEditingController? createdDateController;
  final MessageModel? message;

  final VoidCallback callback;
  const MessageDialog(
      {super.key,
      required this.isAdding,
      this.message,
      required this.groupController,
      required this.messageController,
      required this.timeController,
      this.createdDateController,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Text(isAdding ? "Add Message" : "Edit Message"),
      content: Form(
        key: formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: !isAdding ? message!.groups : "",
              maxLines: null,
              decoration: const InputDecoration(
                labelText: "Group name(s)",
                isDense: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Group name is required";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                groupController.text = newValue!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: null,
              initialValue: !isAdding ? message!.message : "",
              decoration: const InputDecoration(
                labelText: "Message",
                isDense: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Message is required";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                messageController.text = newValue!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // TextFormField(
            //   initialValue: !isAdding ? message!.time : "",
            //   decoration: const InputDecoration(
            //     labelText: "Time",
            //     isDense: true,
            //     border: OutlineInputBorder(),
            //   ),
            //   validator: (value) {
            //     if (value.toString().isEmpty) {
            //       return "Time is required";
            //     } else {
            //       return null;
            //     }
            //   },
            //   onSaved: (newValue) {
            //     timeController.text = newValue!;
            //   },
            // ),
            DateTimePicker(
              initialValue: !isAdding ? message!.time : "",
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 120)),
              // dateLabelText: 'Deadline',
              decoration: const InputDecoration(
                labelText: "Time",
                isDense: true,
                border: OutlineInputBorder(),
              ),

              type: DateTimePickerType.dateTime,
              // onChanged: (val) => print(val),
              validator: (value) {
                if (value.toString().isEmpty) {
                  return "Time is required";
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                timeController.text = newValue!;
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
                          NotificationHelper.sheduleNotification(
                              id: currentTimeStamp.hashCode,
                              title: groupController.text,
                              body: messageController.text,
                              dateTime: DateTime.parse(timeController.text));
                        } else {
                          NotificationHelper.sheduleNotification(
                              id: message!.createdDate.hashCode,
                              title: groupController.text,
                              body: messageController.text,
                              dateTime: DateTime.parse(timeController.text));
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
