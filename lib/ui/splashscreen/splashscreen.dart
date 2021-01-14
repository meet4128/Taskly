import 'package:flutter/material.dart';
import 'package:taskly/ui/homescreen/homescreen.dart';
import 'package:taskly/ui/splashscreen/splashbloc.dart';
import 'package:taskly/utils/colorutitls.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashBloc splashBloc = SplashBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: splashBloc.splashStream,
      builder: (context, snapshot) {
        if (splashBloc.isDelayed) {
          return _splashWidget();
        } else {
          return HomeScreen();
        }
      },
    );
  }

  Widget _splashWidget() {
    return Stack(
      children: [
        Image.asset(
          "homeimage.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.scaleDown,
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: StreamBuilder(
              stream: splashBloc.versionStream,
              builder: (context, AsyncSnapshot<String> snapshot) {
                return Container(
                  height: 60.0 + MediaQuery.of(context).padding.bottom,
                  child: Center(
                    child: Text(
                        snapshot.data == null ? "" : "${"V " + snapshot.data}",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontFamily: 'LatoRegular')),
                  ),
                );
              },
            ),
            body: _bodyWidget()),
      ],
    );
  }

  Widget _bodyWidget() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: ColorUtils.themeColor)),
              onPressed: () {},
              color: ColorUtils.themeColor,
              textColor: Colors.white,
              child: Text("T",
                  style: TextStyle(fontSize: 80, fontFamily: 'AleoRegular')),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text("Taskly",
              style: TextStyle(
                  fontSize: 60,
                  fontFamily: 'LatoRegular',
                  fontWeight: FontWeight.w900))
        ],
      ),
    );
  }

  @override
  void dispose() {
    splashBloc.dispose();
    super.dispose();
  }
}
