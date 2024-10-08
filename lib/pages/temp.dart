import 'package:cr/notifications/notification_helper.dart';
import 'package:flutter/material.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NotificationHelper.sheduleNotification(
                  id: 1,
                    title: "Schedule Notification",
                    body:
                        "Send Message in BSSE Section B group to say everyone to send their group names before 12-04-24.",
                    dateTime: DateTime.parse('2024-04-21 16:22'));
              },
              child: const Text("Schedule Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                NotificationHelper.periodicNotification(
                  id: 0,
                  title: "Periodic Notification",
                  body: "Send Gruop List To Sir Ali",
                );
              },
              child: const Text("Peroidic Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
