//imports
import 'dart:async';

import 'package:package_info/package_info.dart';

// Time for splash screen

// Stream controllers

//Stream sink getter

// Constructor to add data and listener event

//Core Function

// Dispose method

class SplashBloc {
  //Stream Controller
  final _splashStreamController = StreamController<int>();
  final _versionStreamController = StreamController<String>();

  //Stream & Sink
  Stream<int> get splashStream => _splashStreamController.stream;
  Stream<String> get versionStream => _versionStreamController.stream;

  StreamSink<int> get splashSink => _splashStreamController.sink;
  StreamSink<String> get versionSink => _versionStreamController.sink;

  var isDelayed = true;

  //Constructor
  SplashBloc() {
    _waitController(3);
    _versionName();
  }

  //Core Function
  _waitController(int time) async {
    isDelayed = true;
    await Future.delayed(Duration(seconds: time));
    splashSink.add(time);
    isDelayed = false;
  }

  _versionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    //String versionCode = packageInfo.buildNumber;
    versionSink.add(versionName);
  }

  //Disposes
  void dispose() {
    _splashStreamController.close();
    _versionStreamController.close();
  }
}
