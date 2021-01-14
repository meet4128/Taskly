import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taskly/model/TodoModel.dart';
import 'package:taskly/services/todoList.dart';
import 'package:taskly/utils/colorutitls.dart';

class CreateTodoBloc {
  final _createTodoController = BehaviorSubject<ToDoList>();
  final _updateColorController = BehaviorSubject<Color>();

  Stream<ToDoList> get createTodoStream => _createTodoController.stream;

  Stream<Color> get colorStream => _updateColorController.stream;

  ToDoList data;

  createTodo(name, isFavorite, _colorKey) async {
    ToDoList toDoList = ToDoList();
    toDoList.name = name;
    toDoList.favorite = isFavorite;
    toDoList.color = _colorKey;

    data = await createToDore(toDoList);
    print(data.name);
    _createTodoController.sink.add(data);
  }

  updateColor(Color color) {
    _updateColorController.sink.add(color);
  }

  void dispose() {
    _createTodoController.close();
    _updateColorController.close();
  }
}
