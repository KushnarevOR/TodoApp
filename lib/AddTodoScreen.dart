import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:lab1/TodoList.dart';

class AddTodoScreen extends StatelessWidget{
  TextEditingController textController = TextEditingController();
  TextEditingController datetimeController = TextEditingController();

  final Todo? todo;
  AddTodoScreen({Key? key, this.todo}) : super(key: key) {
    if (todo != null) {
      textController.text = todo!.text;
      if (todo!.time != null) {
        datetimeController.text = todo!.time.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Add TODO")
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextField(

              controller: textController,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TODO',
                icon: const Icon(Icons.add_comment)
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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