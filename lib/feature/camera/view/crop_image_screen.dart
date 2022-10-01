import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widgets/crop_image/bottom_navigator_crop_image_widget.dart';
import '../widgets/crop_image/crop_image_header_widget.dart';
import '../widgets/crop_image/show_image_handle.dart';

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {

  bool isRotating = false;

  void onChangeRotating(bool value) {
    setState(() {
      isRotating = value;
    });
  }

  @override
  void initState() {
    isRotating = true;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isRotating = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            const CropImageHeaderWidget(),
            ShowImageHandle(
              isRotating: isRotating,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigatorCropImage(
          isRotating: isRotating,
          onChangeRotating: onChangeRotating,
        ));
  }
}
