import 'package:flutter/material.dart';
import 'package:lab1/AddTodoScreen.dart';
import 'package:lab1/TodoList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter lab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        ),
      home: MainScreen()
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  TodoList list = TodoList();

  void addTodo() async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodoScreen()),
    );

    setState(() {
      list.addTodo(result, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mein Todo List")),
      body: SizedBox(
        // height: 100,
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: list.count(),
            itemBuilder: (BuildContext context, int index) {
              return Text(list.list[index].text, style: TextStyle(fontSize: 18));
            }
        ),
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: addTodo,
          tooltip: 'Add new note',
          child: const Icon(Icons.add)
        )
      ],
    );
  }
}
