import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddTodoScreen extends StatelessWidget{
  TextEditingController textController = TextEditingController();
  TextEditingController datetimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Add TODO")
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: textController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TODO',
                icon: const Icon(Icons.add_comment)
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: DateTimePicker(
              controller: datetimeController,
              type: DateTimePickerType.dateTime,
              dateMask: 'd MMM, yyyy - HH:mm',
              use24HourFormat: true,
              initialTime: TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1))),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              icon: Icon(Icons.event),
              dateLabelText: 'Date/Time',
              timeLabelText: 'Time',
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: textController,
            builder: (context, value, child) {
              return FloatingActionButton(
                onPressed: value.text.isNotEmpty ? () {
                  Navigator.of(context).pop({
                    "text": textController.text.trim(),
                    "datetime": datetimeController.text.isNotEmpty ? datetimeController.text : null,
                  });
                } : null,
                child: Text('ADD'),
              );
            },
          )
        ],
      ),
    );
  }

}