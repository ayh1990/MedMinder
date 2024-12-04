import 'package:flutter/material.dart';
import 'package:medminder/db_helper.dart';
import 'package:medminder/models/intake_event.dart';

class IntakeHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intake History'),
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
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final intakeEvent = snapshot.data![index];
                return ListTile(
                  title: Text('Intake Time: ${intakeEvent.intakeTime}'),
                  subtitle: Text('Medication ID: ${intakeEvent.medicationId}'),
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