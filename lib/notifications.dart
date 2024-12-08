import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void scheduleNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Scheduled Notification',
    'This is the body of the notification',
    tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id', // channelId
        'your channel name', // channelName
        channelDescription: 'your channel description',
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}