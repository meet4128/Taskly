import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskly/model/TodoModel.dart';
import 'package:taskly/ui/projectscreen/updatetask/updateTodobloc.dart';
import 'package:taskly/ui/projectscreen/updatetask/updateprojectscreen.dart';
import 'package:taskly/utils/colorutitls.dart';
import 'package:taskly/utils/dialogUtils.dart';
import 'package:taskly/widget/custom_progress_dialog.dart';

class TaskDetailsProjectScreen extends StatefulWidget {
  final ToDoList toDoList;

  const TaskDetailsProjectScreen({Key key, this.toDoList}) : super(key: key);

  @override
  _TaskDetailsProjectScreenState createState() =>
      _TaskDetailsProjectScreenState();
}

class _TaskDetailsProjectScreenState extends State<TaskDetailsProjectScreen> {
  bool _favorite = false;
  final UpdateTodoBloc _updateTodoBloc = UpdateTodoBloc();
  TextEditingController _projectNameController = TextEditingController();
  ProgressDialog _customProgressDialog = new ProgressDialog();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProjectScreen(
                              selectedColor:
                                  ColorUtils.colorsInfo[widget.toDoList.color],
                              favorite: widget.toDoList.favorite,
                              toDoList: widget.toDoList,
                            )),
                  );
                },
                child: Text(
                  "< Back",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'LatoRegular'),
                ),
              )),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "Delete",
          backgroundColor: Colors.redAccent,
          onPressed: () {
            DialogUtils.onAlertWithCustomImagePressed(
                context,
                "Delete project",
                "Are you sure, you want to delete  Project?",
                "Delete",
                "Cancel",
                true,
                _deleteConfirm);
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.redAccent)),
          child: Icon(
            Icons.delete_forever_outlined,
            size: 30,
          ),
        ),
        body: StreamBuilder(
          stream: _updateTodoBloc.updateTodoStream,
          builder: (context, AsyncSnapshot<ToDoList> snapshot) {
            return SafeArea(child: _screenView());
          },
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget _screenView() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [_bodyHeader(), SizedBox(height: 40), _bodyData()],
          ),
          Positioned(
              right: 20,
              top: 85,
              child: InkWell(
                onTap: () async {
                  var name = _projectNameController.text.toString();
                  var isFavorite = _favorite;
                  if (name == "") {
                    showInSnackBar("Please Enter Project name");
                  } else {
                    _customProgressDialog.showProgressDialog(context);
                    await _updateTodoBloc.updateTodo(name, isFavorite);
                    _customProgressDialog.dismissProgressDialog(context);
                    DialogUtils.onAlertWithCustomImagePressed(
                        context,
                        "Success!",
                        "Task Updated Successfully",
                        "OK",
                        "",
                        false,
                        _deleteConfirm);
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorUtils.themeColor,
                      border: Border.all(
                        color: ColorUtils.themeColor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _bodyHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 110,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
            color: ColorUtils.shadowColor,
            blurRadius: 30.0,
            offset: Offset(0.80, 0.85))
      ], color: Colors.white),
      child: Text("Task",
          style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w300,
              fontFamily: 'LatoRegular')),
    );
  }

  Widget _bodyData() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text("Description:",
                style: TextStyle(fontSize: 18, fontFamily: 'LatoRegular')),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              autofocus: false,
              maxLines: 7,
              controller: _projectNameController,
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Click this task to see more details',
                filled: true,
                fillColor: ColorUtils.textFieldColor,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.textFieldColor),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text("Project: ",
                    style: TextStyle(fontSize: 18, fontFamily: 'LatoRegular')),
                Text(widget.toDoList.name,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'LatoRegular',
                        color: Colors.black38))
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Text("Created at: ",
                    style: TextStyle(fontSize: 18, fontFamily: 'LatoRegular')),
                Text(
                  widget.toDoList.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'LatoRegular',
                      color: Colors.black38),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _deleteConfirm() {}

  @override
  void dispose() {
    _updateTodoBloc.dispose();
    super.dispose();
  }
}
