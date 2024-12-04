import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:medminder/db_helper.dart';
import 'package:medminder/models/intake_event.dart';
import 'package:medminder/models/medication.dart';

class ScanIntakeScreen extends StatefulWidget {
  @override
  _ScanIntakeScreenState createState() => _ScanIntakeScreenState();
}

class _ScanIntakeScreenState extends State<ScanIntakeScreen> {
  late Future<List<Medication>> _medications;

  @override
  void initState() {
    super.initState();
    _medications = DBHelper().getMedications();
    _startNfc();
  }

  void _startNfc() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // Handle NFC tag discovery
      _showMedicationSelectionDialog();
    });
  }

  void _showMedicationSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<Medication>>(
          future: _medications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No medications available.'));
            } else {
              return AlertDialog(
                title: Text('Select Medication'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: snapshot.data!.map((medication) {
                      return ListTile(
                        title: Text(medication.name),
                        onTap: () async {
                          final intakeEvent = IntakeEvent(
                            intakeTime: DateTime.now(),
                            medicationId: medication.id!,
                          );
                          await DBHelper().insertIntakeEvent(intakeEvent);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan for Intake'),
      ),
      body: Center(
        child: Text('Scan your pillbox NFC tag to log intake.'),
      ),
    );
  }
}