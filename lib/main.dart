import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lab1/AddTodoScreen.dart';
import 'package:lab1/TodoDB.dart';
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

  // TodoList list = TodoList();
  var todoDB = TodoDB();
  List<Todo> list = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    readTodoItemsList();
  }

  readTodoItemsList() async {
    var items = await todoDB.getAllTodo();
    items.forEach((item) {
      setState(() {
        var todo = Todo.fromMap(item);
        list.add(todo);
      });
    });
  }

  void addTodo() async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodoScreen()),
    );

    DateTime? dateTime = null;
    if (result['datetime'] != null) {
      dateTime = DateTime.parse(result['datetime']);
    }

    var todo = Todo(text: result['text'], time: dateTime);
    int? savedTodoId = await todoDB.insert(todo);
    var addedTodo = await todoDB.getTodo(savedTodoId);

    setState(() {
      list.add(addedTodo);
    });
  }

  // void changeTodo(int index) async{
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AddTodoScreen(todo: list.list[index])),
  //   );
  //
  //   setState(() {
  //     list.list[index].text = result['text'];
  //     DateTime? dateTime = null;
  //     if (result['datetime'] != null) {
  //       dateTime = DateTime.parse(result['datetime']);
  //       list.list[index].time = dateTime;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mein Todo List")),
      body: SizedBox(
        // height: 100,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: list.length, //list.count(),
          itemBuilder: (BuildContext context, int index) {
            return Center(
                child: InkWell(
                    onTap: () {
                      //changeTodo(index);
                    },
                    child: Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: list[index].time == null ? Text("Time undefined") : Text(list[index].time.toString(),
                                        style: TextStyle(fontSize: 12)),
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(list[index].text, style: TextStyle(fontSize: 18))
                                ),
                              )
                            ]
                        )
                    )
                )
            );
          },
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
