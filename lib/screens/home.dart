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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Medication>> _medications;

  @override
  void initState() {
    super.initState();
    _medications = DBHelper().getMedications();
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
              ).then((value) {
                setState(() {
                  _medications = DBHelper().getMedications();
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Medication>>(
        future: _medications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No medications added.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final medication = snapshot.data![index];
                return ListTile(
                  title: Text(medication.name),
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
                        _medications = DBHelper().getMedications();
                      });
                    },
                  ),
                );
              },
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
            child: Icon(Icons.qr_code_scanner),
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
            tooltip: 'Bluetooth Devices',
          ),
        ],
      ),
    );
  }
}