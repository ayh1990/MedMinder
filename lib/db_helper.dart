import 'package:medminder/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/intake_event.dart';
import 'models/medication.dart';
import 'models/schedule.dart';
import 'models/user_settings.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'medminder.db');
    return await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency INTEGER NOT NULL,
        startDateTime TEXT,
        endDate TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time TEXT NOT NULL,
        frequency INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        medicationId INTEGER NOT NULL,
        FOREIGN KEY (medicationId) REFERENCES medications (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE intake_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        intakeTime TEXT NOT NULL,
        medicationId INTEGER NOT NULL,
        FOREIGN KEY (medicationId) REFERENCES medications (id)
      )
    ''');
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        notificationsEnabled INTEGER NOT NULL,
        soundEnabled INTEGER NOT NULL,
        vibrationEnabled INTEGER NOT NULL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE medications ADD COLUMN dosage TEXT');
    }
    // Add more migrations as needed
  }

  // Medication CRUD operations
  Future<int> insertMedication(Medication medication) async {
    Database db = await database;
    return await db.insert('medications', medication.toMap());
  }

  Future<List<Medication>> getMedications() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  Future<int> deleteMedication(int id) async {
    Database db = await database;
    await flutterLocalNotificationsPlugin.cancel(id);
    return await db.delete('medications', where: 'id = ?', whereArgs: [id]);
  }

  // Schedule CRUD operations
  Future<int> insertSchedule(Schedule schedule) async {
    Database db = await database;
    return await db.insert('schedules', schedule.toMap());
  }

  Future<List<Schedule>> getSchedules() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('schedules');
    return List.generate(maps.length, (i) {
      return Schedule.fromMap(maps[i]);
    });
  }

  Future<int> deleteSchedule(int id) async {
    Database db = await database;
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  // IntakeEvent CRUD operations
  Future<int> insertIntakeEvent(IntakeEvent event) async {
    Database db = await database;
    return await db.insert('intake_events', event.toMap());
  }

  Future<List<IntakeEvent>> getIntakeEvents() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('intake_events');
    return List.generate(maps.length, (i) {
      return IntakeEvent.fromMap(maps[i]);
    });
  }

  Future<int> deleteIntakeEvent(int id) async {
    Database db = await database;
    return await db.delete('intake_events', where: 'id = ?', whereArgs: [id]);
  }

  // UserSettings CRUD operations
  Future<int> insertUserSettings(UserSettings settings) async {
    Database db = await database;
    return await db.insert('user_settings', settings.toMap());
  }

  Future<List<UserSettings>> getUserSettings() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_settings');
    return List.generate(maps.length, (i) {
      return UserSettings.fromMap(maps[i]);
    });
  }

  Future<int> deleteUserSettings(int id) async {
    Database db = await database;
    return await db.delete('user_settings', where: 'id = ?', whereArgs: [id]);
  }
}