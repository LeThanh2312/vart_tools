import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as ImageLib;
import 'package:flutter/material.dart';

class BottomNavigatorCropImage extends StatefulWidget {
  const BottomNavigatorCropImage({
    Key? key,
    required this.listPictureHandle,
    required this.index,
    required this.isRotating,
    required this.onChangeRotating,
  }) : super(key: key);
  final List<File> listPictureHandle;
  final int index;
  final bool isRotating;
  final void Function(bool value) onChangeRotating;

  @override
  State<BottomNavigatorCropImage> createState() =>
      _BottomNavigatorCropImageState();
}

class _BottomNavigatorCropImageState extends State<BottomNavigatorCropImage> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              iconSize: 27.0,
              icon: const Icon(
                Icons.camera_alt,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {});
                _rotateImage(widget.listPictureHandle[widget.index - 1], 90);
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.rotate_left,
              ),
            ),
            IconButton(
              onPressed: () {
                _rotateImage(widget.listPictureHandle[widget.index - 1], -90);
                setState(() {});
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.rotate_right,
              ),
            ),
            IconButton(
              onPressed: () {},
              iconSize: 27.0,
              icon: const Icon(
                Icons.select_all,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.check,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rotateImage(File file, int angle) async {
    setState(() {
      widget.onChangeRotating(true);
    });
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    try {
      File contrastFile = File(file.path);
      ImageLib.Image? contrast =
          ImageLib.decodeImage(contrastFile.readAsBytesSync());
      contrast = ImageLib.copyRotate(contrast!, angle);
      final selectedFile = widget.listPictureHandle[widget.index - 1];
      final newFile =
          await selectedFile.writeAsBytes(ImageLib.encodeJpg(contrast));
      widget.listPictureHandle[widget.index - 1] = newFile;
      imageCache.clear();
      imageCache.clearLiveImages();
      setState(() {});
    } catch (e) {
      e;
    } finally {
      setState(() {
        widget.onChangeRotating(false);
      });
    }
  }
}
