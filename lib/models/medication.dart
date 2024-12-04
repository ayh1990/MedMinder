
import 'package:sqflite/sqflite.dart';

class Medication {
  final int? id;
  final String name;

  Medication({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Medication fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
    );
  }
}