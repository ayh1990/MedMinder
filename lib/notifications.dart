import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medminder/main.dart';

Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'medminder_channel',
    'MedMinder Notifications',
    channelDescription: 'Channel for MedMinder notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
    id,
    title,
    body,
    scheduledTime,
    platformChannelSpecifics,
  );
}