import 'dart:typed_data';
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
  final List<Uint8List> listPictureHandle;
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
                widget.onChangeRotating(true);
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
                widget.onChangeRotating(true);
                setState(() {});
                _rotateImage(widget.listPictureHandle[widget.index - 1], -90);
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

  void _rotateImage(Uint8List file, int angle) async {
    try {
      ImageLib.Image? contrast = ImageLib.decodeImage(file);
      contrast = ImageLib.copyRotate(contrast!, angle);
      widget.listPictureHandle[widget.index - 1] = Uint8List.fromList(ImageLib.encodePng(contrast));
      setState(() {});
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        widget.onChangeRotating(false);
      });
    }
  }
}
