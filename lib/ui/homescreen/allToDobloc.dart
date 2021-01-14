import 'dart:async';

import 'package:taskly/model/TodoModel.dart';
import 'package:taskly/services/todoList.dart';

class AllTodoBloc {
  final _allTodoController = StreamController<List<ToDoList>>();

  Stream<List<ToDoList>> get allTodoStream => _allTodoController.stream;

  // Sink<List<ToDoList>> get allToDotSink => _allTodoController.sink;
  //var _toDos = <ToDoList>[];
  List<ToDoList> data;
  var isLoading = true;

  AllTodoBloc() {
    toDos();
  }

  toDos() async {
    isLoading = true;
    data = await getAllProjects();
    print(data);
    isLoading = false;
    _allTodoController.sink.add(data);
  }

  void dispose() {
    _allTodoController.close();
  }
}
