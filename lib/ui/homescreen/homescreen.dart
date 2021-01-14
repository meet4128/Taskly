import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:taskly/model/TodoModel.dart';
import 'package:taskly/ui/projectscreen/createproject/createprojectscreen.dart';
import 'package:taskly/ui/projectscreen/updatetask/updateprojectscreen.dart';
import 'package:taskly/utils/colorutitls.dart';

import 'allToDobloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AllTodoBloc allTodoBloc = AllTodoBloc();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: _bodyHeader(),
              flex: 20,
            ),
            Flexible(
              child: StreamBuilder(
                  stream: allTodoBloc.allTodoStream,
                  builder: (context, AsyncSnapshot<List<ToDoList>> snapshot) {
                    if (allTodoBloc.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (allTodoBloc.data == null) {
                        Future.delayed(Duration.zero, () {
                          showInSnackBar("Something went wrong!");
                        });
                        return Container();
                      } else {
                        return Container(
                            margin: EdgeInsets.only(
                                top: 40, bottom: 20, left: 20, right: 20),
                            child: _bodyListings(snapshot.data));
                      }
                    }
                  }),
              flex: 80,
            ),
          ],
        ),
        Positioned(
            right: 20,
            top: 140,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateProjectScreen()),
                );
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
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )),
      ],
    );
  }

  Widget _bodyHeader() {
    return Container(
      decoration: BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
            color: ColorUtils.shadowColor,
            blurRadius: 30.0,
            offset: Offset(0.80, 0.85))
      ], color: Colors.white),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Text("Projects",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'LatoRegular')),
        ),
      ),
    );
  }

  Widget _bodyListings(List<ToDoList> _toDoList) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(_toDoList.length, (index) {
        return _cardItem(_toDoList, index);
      }),
    );
  }

  Widget _cardItem(List<ToDoList> _toDoList, index) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateProjectScreen(
                    selectedColor:
                        ColorUtils.colorsInfo[_toDoList[index].color],
                    favorite: _toDoList[index].favorite,
                    toDoList: _toDoList[index],
                  )),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                    color: ColorUtils.colorsInfo[_toDoList[index].color],
                    border: Border.all(
                      color: ColorUtils.itemColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10, right: 15),
                    child: Text('${_toDoList[index].name[0]}',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontFamily: 'LatoRegular')),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.favorite,
                    color:
                        _toDoList[index].favorite ? Colors.red : Colors.white,
                  ))
            ],
          ),
          Container(
            width: 100,
            alignment: Alignment.center,
            child: Text(
              _toDoList[index].name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'LatoRegular',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void dispose() {
    allTodoBloc.dispose();
    super.dispose();
  }
}
