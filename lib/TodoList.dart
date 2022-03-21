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
  String text;
  DateTime? time;
  bool isDone = false;

  Todo({required this.text, this.time});
}