import 'package:flutter/material.dart';

class AddTodoScreen extends StatelessWidget{
  TextEditingController todoController = TextEditingController();

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
              controller: todoController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TODO',
              ),
            )
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: todoController,
            builder: (context, value, child) {
              return FloatingActionButton(
                onPressed: value.text.isNotEmpty ? () {
                  Navigator.pop(context, todoController.text);
                } : null,
                child: Text('ADD'),
              );
            },
          )
          // FloatingActionButton(
          //     onPressed: () {
          //       Navigator.pop(context, todoController.text);
          //     },
          //     child: Text("ADD"))
        ],
      ),
    );
  }

}