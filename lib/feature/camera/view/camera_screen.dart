// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../common/enum/camera_type.dart';
import '../widgets/camera/camera_bottom_widget.dart';
import '../widgets/camera/camera_header_widget.dart';
import '../widgets/camera/show_camera_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, this.cameras}) : super(key: key);
  final List<CameraDescription>? cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  CameraType styleCamera = CameraType.cardID;
  bool isPageFirst = true;
  List<XFile> listPicture = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  void onChangeTypeCamera(CameraType cameraType) {
    setState(() {
      styleCamera = cameraType;
    });
  }

  void onChangePageFirst(bool value) {
    setState(() {
      isPageFirst = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              if (_controller.value.isInitialized)
                ShowCameraWidget(
                  styleCamera: styleCamera,
                  controller: _controller,
                )
              else
                Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              CameraHeaderWidget(
                styleCamera: styleCamera,
                isPageFirst: isPageFirst,
                controller: _controller,
              ),
              CameraBottomWidget(
                onChangeTypeCamera,
                onChangePageFirst,
                styleCamera: styleCamera,
                isPageFirst: isPageFirst,
                controller: _controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
