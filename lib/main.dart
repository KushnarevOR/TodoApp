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
      DateTime? dateTime = null;
      if (result['datetime'] != null) {
        dateTime = DateTime.parse(result['datetime']);
      }
      list.addTodo(result['text'], dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mein Todo List")),
      body: SizedBox(
        // height: 100,
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: list.count(),
          itemBuilder: (BuildContext context, int index) {
            return Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: list.list[index].time == null ? Text("Time undefined") : Text(list.list[index].time.toString(), style: TextStyle(fontSize: 12)),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(list.list[index].text, style: TextStyle(fontSize: 18))
                      ),
                  )
                ]
            );
            // return Text(list.list[index].text, style: TextStyle(fontSize: 18));
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
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
