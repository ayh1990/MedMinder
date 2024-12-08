
class Schedule {
  final int? id;
  final DateTime time;
  final int frequency;
  final DateTime startDate;
  final DateTime endDate;
  final int medicationId;

  Schedule({
    this.id,
    required this.time,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.medicationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'medicationId': medicationId,
    };
  }

  static Schedule fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      time: DateTime.parse(map['time']),
      frequency: map['frequency'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      medicationId: map['medicationId'],
    );
  }
}