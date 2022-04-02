class TodoList {
  List<Todo> list = List.empty(growable: true);

  void addTodo(String text, DateTime? time) {
    var todo = Todo(text: text, time: time);
    list.add(todo);
  }

  TodoList() {
    list.add(Todo(text: "First"));
    list.add(Todo(text: "Second"));
    list.add(Todo(text: "Third"));
  }

  int count() {
    return list.length;
  }
}

class Todo {
  int? id;
  String text = "";
  DateTime? time;
  bool isDone = false;

  Todo({required this.text, this.time});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "text": text,
      "datetime": time != null ? time.toString() : null,
      "isDone": isDone == true ? 1 : 0,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.text = map["text"];
    this.time = map["datetime"] != null ? DateTime.parse(map["datetime"]) : null;
    this.isDone = map["isDone"] == 1;
  }
}