import 'package:flutter/material.dart';
import 'package:medminder/models/medication.dart';
import 'package:medminder/models/intake_event.dart';
import 'package:medminder/db_helper.dart';

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  MedicationDetailScreen({required this.medication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
      ),
      body: FutureBuilder<List<IntakeEvent>>(
        future: DBHelper().getIntakeEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No intake events recorded.'));
          } else {
            final intakeEvents = snapshot.data!.where((event) => event.medicationId == medication.id).toList();
            return ListView.builder(
              itemCount: intakeEvents.length,
              itemBuilder: (context, index) {
                final intakeEvent = intakeEvents[index];
                return ListTile(
                  title: Text('Intake Time: ${intakeEvent.intakeTime}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await DBHelper().deleteIntakeEvent(intakeEvent.id!);
                      (context as Element).reassemble();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}