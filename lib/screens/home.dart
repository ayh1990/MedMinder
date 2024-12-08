import 'package:flutter/material.dart';
import 'package:medminder/db_helper.dart';
import 'package:medminder/models/medication.dart';
import 'package:medminder/screens/add_medication.dart';
import 'package:medminder/screens/medication_detail.dart';
import 'package:medminder/screens/scan_intake.dart';
import 'package:medminder/screens/intake_history.dart';
import 'package:medminder/screens/bluetooth.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Medication>> medications;

  @override
  void initState() {
    super.initState();
    medications = DBHelper().getMedications();
  }

  String _formatFrequency(int frequency) {
    if (frequency < 60) {
      return '$frequency minutes';
    } else if (frequency < 1440) {
      return '${frequency ~/ 60} hours';
    } else if (frequency < 10080) {
      return '${frequency ~/ 1440} days';
    } else {
      return '${frequency ~/ 10080} weeks';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MedMinder'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMedicationScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Medication>>(
        future: medications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No medications added.'));
          } else {
            final currentMedications = snapshot.data!.where((med) => med.endDate == null || med.endDate!.isAfter(DateTime.now())).toList();
            final pastMedications = snapshot.data!.where((med) => med.endDate != null && med.endDate!.isBefore(DateTime.now())).toList();

            return ListView(
              children: [
                if (currentMedications.isNotEmpty) ...[
                  ListTile(
                    title: Text('Current Medications', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...currentMedications.map((medication) => ListTile(
                    title: Text(medication.name),
                    subtitle: Text('Dosage: ${medication.dosage}, Frequency: ${_formatFrequency(medication.frequency)}, Start: ${medication.startDateTime?.toLocal().toString() ?? 'N/A'}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicationDetailScreen(medication: medication),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DBHelper().deleteMedication(medication.id!);
                        setState(() {
                          medications = DBHelper().getMedications();
                        });
                      },
                    ),
                  )),
                ],
                if (pastMedications.isNotEmpty) ...[
                  ListTile(
                    title: Text('Past Medications', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ...pastMedications.map((medication) => ListTile(
                    title: Text(medication.name),
                    subtitle: Text('Dosage: ${medication.dosage}, Frequency: ${_formatFrequency(medication.frequency)}, Start: ${medication.startDateTime?.toLocal().toString() ?? 'N/A'}, End: ${medication.endDate?.toLocal().toString() ?? 'N/A'}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicationDetailScreen(medication: medication),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DBHelper().deleteMedication(medication.id!);
                        setState(() {
                          medications = DBHelper().getMedications();
                        });
                      },
                    ),
                  )),
                ],
              ],
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'scan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanIntakeScreen()),
              );
            },
            child: Icon(Icons.nfc),
            tooltip: 'Scan for Intake',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'history',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IntakeHistoryScreen()),
              );
            },
            child: Icon(Icons.history),
            tooltip: 'Intake History',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'bluetooth',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BluetoothScreen()),
              );
            },
            child: Icon(Icons.bluetooth),
            tooltip: 'Bluetooth',
          ),
        ],
      ),
    );
  }
}