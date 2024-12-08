class Medication {
  final int? id;
  final String name;
  final String dosage;
  final int frequency; // Frequency in minutes
  final DateTime? startDateTime;
  final DateTime? endDate;

  Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    this.startDateTime,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'startDateTime': startDateTime?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  static Medication fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      startDateTime: map['startDateTime'] != null ? DateTime.parse(map['startDateTime']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }
}