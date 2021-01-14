import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:taskly/constants/constants.dart';
import 'package:taskly/model/TodoModel.dart';


// GET ALL PROJECTS
Future<List<ToDoList>> getAllProjects() async {
  final response =
      await http.get("${Constants.SERVER_URL + "#get-all-projects"}", headers: {
    'Authorization': 'Bearer ${Constants.API_TOKEN}',
  });

  return response.statusCode == 200 ? allTodoListFromJson(response.body) : null;
}

// CREATE PROJECTS
Future<ToDoList> createToDore(ToDoList toDoList) async {
  Map data = {
    'name': toDoList.name,
    'favorite': toDoList.favorite,
    'color': toDoList.color,
  };
  //encode Map to JSON
  var body = json.encode(data);
  final response =
      await http.post("${Constants.SERVER_URL + "#create-a-new-project"}",
          headers: {
            'Authorization': 'Bearer ${Constants.API_TOKEN}',
            'Content-Type': 'application/json',
          },
          body: body);
  print(response.body);
  return response.statusCode == 200
      ? createTodoDetailFromJson(response.body)
      : null;
}

// UPDATE PROJECTS
Future<ToDoList> updateToDore(ToDoList toDoList) async {
  Map data = {
    'name': toDoList.name,
    'favorite': toDoList.favorite,
  };
  //encode Map to JSON
  var body = json.encode(data);
  final response =
  await http.post("${Constants.SERVER_URL + "#update-a-project"}",
      headers: {
        'Authorization': 'Bearer ${Constants.API_TOKEN}',
        'Content-Type': 'application/json',
      },
      body: body);
  print(response.body);
  return response.statusCode == 200
      ? createTodoDetailFromJson(response.body)
      : null;
}
