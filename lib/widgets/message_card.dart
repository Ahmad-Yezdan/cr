import 'package:cr/models/message_model.dart';
import 'package:cr/notifications/notification_helper.dart';
import 'package:cr/providers/major_provider.dart';
import 'package:cr/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MessageCard extends StatelessWidget {
  MessageCard({
    super.key,
    required this.message,
    required this.theme,
    required this.provider,
    required this.context,
  });

  final MessageModel message;
  final ThemeData theme;
  final MajorProvider provider;
  final BuildContext context;

  var groupController = TextEditingController();
  var messageController = TextEditingController();
  var timeController = TextEditingController();

  void update() async {
    Provider.of<MajorProvider>(context, listen: false).updateMessage(
        MessageModel(
            id: message.id,
            groups: groupController.text,
            message: messageController.text,
            time: timeController.text),
        context);

    if (!context.mounted) {
      return; //the widget is not mounted don't do anything
    }
  }

  void showUpdateMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return MessageDialog(
            isAdding: false,
            groupController: groupController,
            messageController: messageController,
            timeController: timeController,
            message: message,
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
            message.groups,
            style: theme.textTheme.titleLarge,
          ),
          subtitle: Text(
            "Time: ${DateFormat.yMd().add_jm().format(DateTime.parse(message.time))}",
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
                              text: "Message: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          TextSpan(text: message.message),
                        ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: showUpdateMessage,
                            child: const Text("Edit")),
                        TextButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Have You deliverd this message?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () {
                                            provider.deleteMessage(
                                                message.id!, context);
                                            NotificationHelper.cancel(
                                                id: message
                                                    .createdDate!.hashCode);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yes")),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text("Mark as delivered")),
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
