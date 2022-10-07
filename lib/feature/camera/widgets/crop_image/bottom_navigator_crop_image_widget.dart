import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/crop_picture_bloc.dart';
import 'package:opencv4/core/imgproc.dart';

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
      await ImgProc.initOpenCV();
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
                onPressed: () {
                  if (_platformVersion) {
                    context
                        .read<CameraPictureViewModel>()
                        .add(RotateImageEvent(angle: ImgProc.ROTATE_90_COUNTERCLOCKWISE));
                    setState(() {});
                  }
                },
                iconSize: 27.0,
                icon: const Icon(
                  Icons.rotate_left,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_platformVersion) {
                    context
                        .read<CameraPictureViewModel>()
                        .add(RotateImageEvent(angle: ImgProc.ROTATE_90_CLOCKWISE));
                    setState(() {});
                  }else {
                    initPlatformState();
                  }
                },
                iconSize: 27.0,
                icon: const Icon(
                  Icons.rotate_right,
                ),
              ),
              IconButton(
                onPressed: () {
                  context
                      .read<CameraPictureViewModel>()
                      .add(ResetPointsEvent());
                  setState(() {});
                },
                iconSize: 27.0,
                icon: const Icon(
                  Icons.select_all,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<CameraPictureViewModel>().add(CropImageEvent());
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
}
