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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TODO',
              ),
            )
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, todoController.text);
              },
              child: Text("ADD"))
        ],
      ),
    );
  }

}