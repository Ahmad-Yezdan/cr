import 'package:cr/db/database_helper.dart';
import 'package:cr/models/message_model.dart';
import 'package:cr/providers/major_provider.dart';
import 'package:cr/widgets/message_card.dart';
import 'package:cr/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
 final groupController = TextEditingController();
  final messageController = TextEditingController();
  final timeController = TextEditingController();
  final createdDateController = TextEditingController();

  void save() async {
    Provider.of<MajorProvider>(context, listen: false).saveMessage(
        MessageModel(
            groups: groupController.text,
            message: messageController.text,
            time: timeController.text,
            createdDate:createdDateController.text),
        context);

    if (!context.mounted) {
      return; //the widget is not mounted don't do anything
    }
  }

  void addMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return MessageDialog(
            isAdding: true,
            groupController: groupController,
            messageController: messageController,
            timeController: timeController,
            createdDateController:createdDateController,
            callback: save);
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
          "Messages",
          style: theme.textTheme.headlineMedium,
        ),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: DataBaseHelper.instance.readAllMessages(),
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
                List<MessageModel> savedMessages = snapshot.data!;
                return ListView.builder(
                  itemCount: savedMessages.length,
                  itemBuilder: (context, index) {
                    MessageModel message = savedMessages[index];

                    return MessageCard(
                      message: message,
                      theme: theme,
                      provider: provider,
                      context: context,
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No messages found."),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMessage,
        child: const Icon(Icons.add),
      ),
    );
  }
}