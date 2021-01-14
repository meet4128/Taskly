import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taskly/model/TodoModel.dart';
import 'package:taskly/services/todoList.dart';

class UpdateTodoBloc {
  final _updateTodoController = BehaviorSubject<ToDoList>();
  final _tasksListController = BehaviorSubject<List<String>>();
  final _updateColorController = BehaviorSubject<Color>();

  Stream<ToDoList> get updateTodoStream => _updateTodoController.stream;
  Stream<List<String>> get taskListStream => _tasksListController.stream;
  Stream<Color> get colorStream => _updateColorController.stream;

  ToDoList data;

  updateTodo(name, isFavorite) async {
    ToDoList toDoList = ToDoList();
    toDoList.name = name;
    toDoList.favorite = isFavorite;

    data = await updateToDore(toDoList);
    print(data.name);
    _updateTodoController.sink.add(data);
  }

  updateColor(Color color){
    _updateColorController.sink.add(color);
  }

  UpdateTodoBloc() {
    List<String> _taskList = List();
    _taskList.add("Click this task to see more details");
    _taskList.add("You can add subtasks here! ✅");
    _taskList.add("Add a new task ➕");
    _taskList.add("Schedule this task 📅");
    _taskList.add("Add a section from the project menu in...");
    _tasksListController.sink.add(_taskList);
  }

  void dispose() {
    _updateTodoController.close();
    _tasksListController.close();
    _updateColorController.close();
  }
}
