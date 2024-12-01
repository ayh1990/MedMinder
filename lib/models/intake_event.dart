import 'package:core_data/core_data.dart';
import 'package:sqflite/sqflite.dart';

class IntakeEvent {
  final int? id;
  final DateTime intakeTime;
  final int medicationId;

  IntakeEvent({
    this.id,
    required this.intakeTime,
    required this.medicationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'intakeTime': intakeTime.toIso8601String(),
      'medicationId': medicationId,
    };
  }

  static IntakeEvent fromMap(Map<String, dynamic> map) {
    return IntakeEvent(
      id: map['id'],
      intakeTime: DateTime.parse(map['intakeTime']),
      medicationId: map['medicationId'],
    );
  }
}