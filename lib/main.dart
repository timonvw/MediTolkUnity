import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter_liquidcore/liquidcore.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  bool paused = false;

  //unity related properties
  UnityWidgetController _unityWidgetController;
  String unityMessage;

  //nodejs related properties
  MicroService _microService;
  JSContext _jsContext;

  String _jsContextResponse = '<empty>';
  String _microServiceResponse = '<empty>';
  int _microServiceWorld = 0;

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
                    textAlign: TextAlign.center,
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
    this.initMicroService();
  }




  // *************************************************
  // nodejs methods
  // *************************************************
  @override
  void dispose() {
    if (_microService != null) {
      // Exit and free up the resources.
      // _microService.exitProcess(0); // This API call might not always be available.
      _microService.emit('exit');
    }
    if (_jsContext != null) {
      // Free up the context resources.
      _jsContext.cleanUp();
    }
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initMicroService() async {
    if (_microService == null) {
      String uri;

      // Android doesn't allow dashes in the res/raw directory.
      uri =
          "android.resource://Resource/server.js";
//      uri = "@flutter_assets/Resources/server.js";
      //uri = "https://raw.githubusercontent.com/j0j00/flutter_liquidcore/master/example/ios/Resources/liquidcore_sample.js";

      _microService = new MicroService(uri);
      await _microService.addEventListener('ready',
          (service, event, eventPayload) {
        // The service is ready.
        if (!mounted) {
          return;
        }
        //_emit();
      });

      await _microService.addEventListener('pong',
          (service, event, eventPayload) {
        if (!mounted) {
          return;
        }
        _setMicroServiceResponse(eventPayload['message']);
      });

      // Start the service.
      await _microService.start();
    }

    if (_microService.isStarted) {
      _emit();
    }
  }

  void _emit() async {
    // Send the name over to the MicroService.
//    await _microService.emit('ping', 'World ${++_microServiceWorld}');
  }

  void _setMicroServiceResponse(message) {
    if (!mounted) {
      print("microService: widget not mounted");
      return;
    }

    setState(() {
      _microServiceResponse = message;
    });
  }
}
