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
  UnityWidgetController _unityWidgetMessageController;
  String unityMessage;
  bool paused = false;

  @override
  void initState() {
    super.initState();
    this.unityMessage = 'Started';
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
              onUnityMessage: unityMessageCallback,
            ),
            Positioned(
              bottom: 40.0,
              left: 80.0,
              right: 80.0,
              child: MaterialButton(
                onPressed: () {
                  if (paused) {
                    _unityWidgetController.resume();
                    setState(() {
                      paused = false;
                    });
                  } else {
                    _unityWidgetController.pause();
                    setState(() {
                      paused = true;
                    });
                  }
                },
                color: Colors.blue[500],
                child: Text(paused ? 'Start' : 'Pauze'),
              ),
            ),
            Positioned(
              bottom: 20.0,
              left: 80.0,
              right: 80.0,
              child: Container(
                  width: 20,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3),
                    border: Border(
                      top: BorderSide(width: 1.0, color: Color(0xFF003366)),
                      left: BorderSide(width: 1.0, color: Color(0xFF003366)),
                      right: BorderSide(width: 1.0, color: Color(0xFF003366)),
                      bottom: BorderSide(width: 1.0, color: Color(0xFF003366)),
                    ),
                  ),
                  child: Text(
                    unityMessage,
                    style: TextStyle(
                      color: Color(0xFF003366),
                    ),
                  )),
            ),
          ],
        )),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void unityViewCreatedCallback(controller) {
    this._unityWidgetController = controller;
    this.unityMessage = 'Unity on';
  }

  // Callback that handles the onUnityMessage Event
  void unityMessageCallback(controller, dynamic) {
    this._unityWidgetMessageController = controller;
    this.unityMessage = 'test';
  }
}
