import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController _unityWidgetController;
  bool paused = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Flutter 3D Model Demo'),
        ),
        body: Container(
            child: Stack(
          children: <Widget>[
            UnityWidget(
              onUnityViewCreated: unityViewCreatedCallback,
            ),
          ],
        )),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void unityViewCreatedCallback(controller) {
    this._unityWidgetController = controller;
  }
}
