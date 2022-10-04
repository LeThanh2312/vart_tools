import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv4/opencv4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _opencv4Plugin = Opencv4();
  final ImagePicker _picker = ImagePicker();
  Image? imageView;

  Future<void> getImage() async {
    try {
      final bytes =
          (await rootBundle.load("assets/nobita.jpeg")).buffer.asUint8List();
      final result = await _opencv4Plugin.rotate(bytes, 0);
      if (result != null) {
        imageView = Image.memory(result as Uint8List);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _opencv4Plugin.getOpenCVVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              imageView != null ? imageView! : const SizedBox(),
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                  onPressed: () {
                    getImage();
                  },
                  child: Text("Image"))
            ],
          ),
        ),
      ),
    );
  }
}
