import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lab1/AddTodoScreen.dart';
import 'package:lab1/TodoDB.dart';
import 'package:lab1/TodoList.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
    tz.initializeTimeZones();
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

  final sound = 'notification_sound.mp3';
  void showNotification(int? id, String title, DateTime localtime) async {
    int notifyID = id == null ? 0 : id;
    var notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          'ToDoList id 2',
          'ToDoList',
          channelDescription: 'ToDoList channel',
          channelShowBadge: true,
          priority: Priority.high,
          importance: Importance.max,
          icon: 'ic_stat_name',
          sound: RawResourceAndroidNotificationSound('notification_sound'),
          playSound: true,
        ));
    // String body = DateFormat.yMMMd().format(localtime);

    await flutterLocalNotificationsPlugin.schedule(
        notifyID, 'Take it, boy!', title, localtime, notificationDetails,
        androidAllowWhileIdle: true);

  }

  // Future<void> showNotification(int? id, String text, DateTime time) async {
  //   id = id == null ? 0 : id;
  //   final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  //   tz.setLocalLocation(tz.getLocation(currentTimeZone));
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id,
  //     'Take it, boy!',
  //     text,
  //     tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'Mein channel id', 'Mein channel',
  //         channelDescription: 'Mein channel description',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         // icon: "notification_icon",
  //       )
  //     ),
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  // }

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
    if(dateTime != null) {
      showNotification(savedTodoId, result['text'], dateTime);
    }

    setState(() {
      list.add(addedTodo);
    });
  }

  void changeTodo(int index) async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodoScreen(todo: list[index])),
    );

    DateTime? dateTime = null;
    if (result['datetime'] != null) {
      dateTime = DateTime.parse(result['datetime']);
    }

    if(dateTime != null) {
      showNotification(list[index].id, result['text'], dateTime);
    }

    setState(() {
      list[index].text = result['text'];
      list[index].time = dateTime;
    });

    await todoDB.update(list[index]);
  }

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
                      changeTodo(index);
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
