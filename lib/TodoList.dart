class TodoList {
  List<Todo> list = List.empty(growable: true);

  void addTodo(String text, DateTime? time) {
    var todo = Todo(text: text, time: time);
    list.add(todo);
  }
}

class Todo {
  String text;
  DateTime? time;
  bool isDone = false;

  Todo({required this.text, this.time});
}