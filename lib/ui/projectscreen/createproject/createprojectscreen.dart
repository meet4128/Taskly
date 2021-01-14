import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskly/model/TodoModel.dart';
import 'package:taskly/ui/homescreen/homescreen.dart';
import 'package:taskly/ui/projectscreen/createproject/createTodobloc.dart';
import 'package:taskly/utils/colorutitls.dart';
import 'package:taskly/utils/dialogUtils.dart';
import 'package:taskly/widget/custom_progress_dialog.dart';

class CreateProjectScreen extends StatefulWidget {
  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  bool _favorite = false;
  final CreateTodoBloc createTodoBloc = CreateTodoBloc();
  TextEditingController _projectNameController = TextEditingController();
  ProgressDialog customProgressDialog = new ProgressDialog();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color _selectedColor;
  int _colorKey;

  @override
  void initState() {
    _selectedColor = Color(0xff808080);
    _colorKey = 47;
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
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
        body: StreamBuilder(
          stream: createTodoBloc.createTodoStream,
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
                    customProgressDialog.showProgressDialog(context);
                    await createTodoBloc.createTodo(
                        name, isFavorite, _colorKey);
                    customProgressDialog.dismissProgressDialog(context);
                    DialogUtils.onAlertWithCustomImagePressed(
                        context,
                        "Success!",
                        "Task Created Successfully",
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
      child: Text("Projects",
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
        children: [
          ListTile(
            leading: Text("Create a new project",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'LatoRegular')),
            trailing: Icon(
              Icons.favorite_border,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              autofocus: false,
              controller: _projectNameController,
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Project name',
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
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Text("Color:",
                    style: TextStyle(fontSize: 18, fontFamily: 'LatoRegular')),
                StreamBuilder(
                  stream: createTodoBloc.colorStream,
                  builder: (context, AsyncSnapshot<Color> snapshot) {
                    return Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(left: 15),
                        child: FloatingActionButton(
                          onPressed: () {
                            DialogUtils.showColorPiker(
                                context, _functionColor, _selectedColor);
                          },
                          backgroundColor: _selectedColor,
                          elevation: 0,
                        ));
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Text("Favorite:",
                    style: TextStyle(fontSize: 18, fontFamily: 'LatoRegular')),
                CupertinoSwitch(
                  value: _favorite,
                  //trackColor: _lights ? Colors.grey : Colors.greenAccent,
                  activeColor: !_favorite ? Colors.grey : ColorUtils.themeColor,
                  onChanged: (bool value) {
                    _favorite = _favorite ? false : true;
                    setState(() {});
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tasks:",
                      style:
                          TextStyle(fontSize: 18, fontFamily: 'LatoRegular')),
                  Icon(Icons.add)
                ],
              )),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5),
            child: Container(
              height: 1.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _functionColor(Color color, int key) {
    print("called");
    _selectedColor = color;
    _colorKey = key;
    createTodoBloc.updateColor(color);
  }

  void _deleteConfirm() {}

  @override
  void dispose() {
    createTodoBloc.dispose();
    super.dispose();
  }
}
