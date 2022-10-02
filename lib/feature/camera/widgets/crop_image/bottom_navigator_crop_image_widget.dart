import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:opencv/opencv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/crop_picture_bloc.dart';

class BottomNavigatorCropImage extends StatefulWidget {
  const BottomNavigatorCropImage({
    Key? key,
    required this.isRotating,
    required this.onChangeRotating,
  }) : super(key: key);
  final bool isRotating;
  final void Function(bool value) onChangeRotating;

  @override
  State<BottomNavigatorCropImage> createState() =>
      _BottomNavigatorCropImageState();
}

class _BottomNavigatorCropImageState extends State<BottomNavigatorCropImage> {
  bool _platformVersion = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    String? platformVersion;
    try {
      await OpenCV.platformVersion;
    } catch (e) {
      platformVersion = '==== error ${e.toString()}';
    } finally {
      _platformVersion = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraPictureViewModel, CropAndFilterPictureState>(
        builder: (context, state) {
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
                  context.read<CameraPictureViewModel>().add(RotateImageEvent(angle: -90));
                  setState(() {});
                },
                iconSize: 27.0,
                icon: const Icon(
                  Icons.rotate_left,
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.onChangeRotating(true);
                  context.read<CameraPictureViewModel>().add(RotateImageEvent(angle: 90));
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
                  Navigator.of(context).pop();
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
    });
  }

  Future<void> _rotateImage(Uint8List file, int angle) async {
    if (_platformVersion) {
      try {
        var res = await ImgProc.rotate(file, angle);
        //widget.listPictureHandle[widget.index - 1] = res as Uint8List;
        widget.onChangeRotating(false);
        setState(() {});
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          widget.onChangeRotating(false);
        });
      }
    } else {
      initPlatformState();
    }
  }
}
