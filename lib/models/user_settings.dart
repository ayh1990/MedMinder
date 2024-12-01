import 'package:sqflite/sqflite.dart';

class UserSettings {
  final int? id;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;

  UserSettings({
    this.id,
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
      'soundEnabled': soundEnabled ? 1 : 0,
      'vibrationEnabled': vibrationEnabled ? 1 : 0,
    };
  }

  static UserSettings fromMap(Map<String, dynamic> map) {
    return UserSettings(
      id: map['id'],
      notificationsEnabled: map['notificationsEnabled'] == 1,
      soundEnabled: map['soundEnabled'] == 1,
      vibrationEnabled: map['vibrationEnabled'] == 1,
    );
  }
}