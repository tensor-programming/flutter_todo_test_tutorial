import 'dart:async';

import 'package:test_todo/model.dart';

class TodoLogic {
  List<Todo> list = [];
  StreamController<List<Todo>> streamController = StreamController();

  void addTodo(String body) {
    list.add(
      Todo(body: body, finished: false),
    );

    _updateStream();
  }

  void addTodoItem(Todo todo) {
    list.add(todo);
    _updateStream();
  }

  void removeTodoByIndex(int i) {
    if (i < list.length) {
      list.removeAt(i);
      _updateStream();
    }
  }

  void removeFinishedTodos() {
    list.removeWhere((element) => element.finished == true);

    _updateStream();
  }

  void clearTodos() {
    list.clear();

    _updateStream();
  }

  void markItemFinished(int index, bool value) {
    list[index].finished = value;

    _updateStream();
  }

  void _updateStream() {
    streamController.sink.add(list);
  }

  void dispose() {
    streamController.close();
  }
}
