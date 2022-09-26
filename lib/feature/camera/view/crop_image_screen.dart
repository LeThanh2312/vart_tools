import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:extended_image_library/extended_image_library.dart';
import '../../../common/crop_image.dart';
import '../widgets/crop_image/bottom_navigator_crop_image_widget.dart';
import '../widgets/crop_image/crop_image_header_widget.dart';
import '../widgets/crop_image/show_image_handle.dart';

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({
    Key? key,
    required this.listPictureOrigin,
  }) : super(key: key);
  final List<File> listPictureOrigin;

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  List<Uint8List> listPictureHandle = [];

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

  final GlobalKey _cropperKey = GlobalKey(debugLabel: 'cropperKey');

  final _cropController = CropController();

  @override
  void initState() {
    isRotating = true;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _copyFile();
      isRotating = false;
    });
  }

  void _copyFile() async {
        for (var item in widget.listPictureOrigin) {
      final image = await item.readAsBytes();
      listPictureHandle.add(image);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            CropImageHeaderWidget(listPictureHandle: listPictureHandle),
            ShowImageHandle(
              listPictureHandle: listPictureHandle,
              isRotating: isRotating,
              index: index,
              onChangeIndex: onChangeIndex,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigatorCropImage(
          listPictureHandle: listPictureHandle,
          index: index,
          isRotating: isRotating,
          onChangeRotating: onChangeRotating,
        ));
  }
}
