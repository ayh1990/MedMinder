import 'package:flutter/material.dart';
import 'package:medminder/db_helper.dart';
import 'package:medminder/models/medication.dart';
import 'package:medminder/widgets/frequency_slider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medminder/main.dart';
import 'package:timezone/timezone.dart' as tz;

class AddMedicationScreen extends StatefulWidget {
  @override
  AddMedicationScreenState createState() => AddMedicationScreenState();
}

class AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  DateTime? _startDateTime;
  DateTime? _endDate;
  int _frequency = 60; // Default to 1 hour

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Medication Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a medication name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(labelText: 'Dosage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dosage';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_startDateTime == null ? 'Start Date & Time' : _startDateTime!.toLocal().toString()),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _startDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
              ListTile(
                title: Text(_endDate == null ? 'End Date' : _endDate!.toLocal().toString().split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _endDate) {
                    setState(() {
                      _endDate = picked;
                    });
                  }
                },
              ),
              FrequencySlider(
                onFrequencyChanged: (frequency) {
                  setState(() {
                    _frequency = frequency;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final medication = Medication(
                      name: _nameController.text,
                      dosage: _dosageController.text,
                      frequency: _frequency,
                      startDateTime: _startDateTime,
                      endDate: _endDate,
                    );
                    await DBHelper().insertMedication(medication);
                    _scheduleNotifications(medication);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Medication'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scheduleNotifications(Medication medication) async {
    final now = DateTime.now();
    final start = medication.startDateTime ?? now;
    final end = medication.endDate ?? DateTime(now.year + 1);

    for (var date = start; date.isBefore(end); date = date.add(Duration(minutes: medication.frequency))) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        medication.id!,
        'Time to take your medication',
        '${medication.name} - ${medication.dosage}',
        tz.TZDateTime.from(date, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'medminder_channel',
            'MedMinder Notifications',
            channelDescription: 'Channel for MedMinder notifications',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> scheduleNotification(DateTime scheduledDate) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'This is the body of the notification',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}