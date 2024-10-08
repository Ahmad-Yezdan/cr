import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static init() {
    _notifications.initialize(
      const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings()),
    );
    tz.initializeTimeZones();
  }

  static sheduleNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime dateTime}) async {
    var androidDetails = const AndroidNotificationDetails('0', 'Messages',
        importance: Importance.max, priority: Priority.high);
    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(id, title, body,
        tz.TZDateTime.from(dateTime, tz.local), notificationDetails,
        //this line is for ios
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        //this line is for android
        androidScheduleMode: AndroidScheduleMode.alarmClock);
  }

  static periodicNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    var androidDetails = const AndroidNotificationDetails('1', 'Tasks',
        importance: Importance.max, priority: Priority.high);
    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future cancel({required int id}) async {
    await _notifications.cancel(id);
  }
}
