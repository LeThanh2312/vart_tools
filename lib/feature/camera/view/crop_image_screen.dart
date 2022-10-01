import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widgets/crop_image/bottom_navigator_crop_image_widget.dart';
import '../widgets/crop_image/crop_image_header_widget.dart';
import '../widgets/crop_image/show_image_handle.dart';

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({
    Key? key,
    required this.listPictureHandle,
  }) : super(key: key);
  final List<Uint8List> listPictureHandle;

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  int index = 1;

  bool isRotating = false;

  void onChangeRotating(bool value) {
    setState(() {
      isRotating = value;
    });
  }

  void onChangeIndex(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  void initState() {
    isRotating = true;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isRotating = false;
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            CropImageHeaderWidget(listPictureHandle: widget.listPictureHandle),
            ShowImageHandle(
              listPictureHandle: widget.listPictureHandle,
              isRotating: isRotating,
              index: index,
              onChangeIndex: onChangeIndex,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigatorCropImage(
          listPictureHandle: widget.listPictureHandle,
          index: index,
          isRotating: isRotating,
          onChangeRotating: onChangeRotating,
        ));
  }
}
