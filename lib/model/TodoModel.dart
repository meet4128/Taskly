import 'dart:convert';

List<ToDoList> allTodoListFromJson(String str) =>
    List<ToDoList>.from(json.decode(str).map((x) => ToDoList.fromJson(x)));

ToDoList createTodoDetailFromJson(String str) =>
    ToDoList.fromJson(json.decode(str));

class ToDoList {
  int id;
  String name;
  int commentCount;
  int order;
  int color;
  bool shared;
  int syncId;
  bool favorite;
  bool inboxProject;

  ToDoList(
      {this.id,
        this.name,
        this.commentCount,
        this.order,
        this.color,
        this.shared,
        this.syncId,
        this.favorite,
        this.inboxProject});

  ToDoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    commentCount = json['comment_count'];
    order = json['order'];
    color = json['color'];
    shared = json['shared'];
    syncId = json['sync_id'];
    favorite = json['favorite'];
    inboxProject = json['inbox_project'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['comment_count'] = this.commentCount;
    data['order'] = this.order;
    data['color'] = this.color;
    data['shared'] = this.shared;
    data['sync_id'] = this.syncId;
    data['favorite'] = this.favorite;
    data['inbox_project'] = this.inboxProject;
    return data;
  }
}
