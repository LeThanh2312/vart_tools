import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:extended_image_library/extended_image_library.dart';

import '../../../common/crop_image.dart';

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({
    Key? key,
    required this.picture,
  }) : super(key: key);
  final List<File> picture;

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  int index = 1;
  final GlobalKey _cropperKey = GlobalKey(debugLabel: 'cropperKey');

  //late Rect _rect;
  final _cropController = CropController();
  int _rotationTurns = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: 5.0.h, right: 20.0, left: 20.0, bottom: 5.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: Stack(
          //     children: [
          //       Center(
          //         child: RotatedBox(
          //           quarterTurns: _rotationTurns,
          //           child: Image.file(
          //             File(widget.picture[index - 1].path),
          //             fit: BoxFit.contain,
          //             width: 70.0.w,
          //             height: double.infinity,
          //           ),
          //         ),
          //       ),
          //       // IgnorePointer(
          //       //   child: ClipPath(
          //       //     clipper:_CropAreaClipper(_rect, 0),
          //       //     child: Container(
          //       //       width: double.infinity,
          //       //       height: double.infinity,
          //       //       color:  Colors.black.withAlpha(100),
          //       //     ),
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 68.0.h,
            child: Crop(
              image: File(widget.picture[index - 1].path).readAsBytesSync(),
              controller: _cropController,
              onCropped: (image) {
              },
              rotationTurns: _rotationTurns,
            ),
          ),

          // Cropper(
          //   cropperKey: _cropperKey,
          //   rotationTurns: _rotationTurns,
          //   image: Image.memory(
          //       File(widget.picture[index - 1].path).readAsBytesSync()),
          //   onScaleStart: (details) {},
          //   onScaleUpdate: (details) {},
          //   onScaleEnd: (details) {},
          // ),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (index > 1) index--;
                    setState(() {});
                  },
                  iconSize: 27.0,
                  icon: const Icon(
                    Icons.arrow_circle_left_outlined,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('$index/${widget.picture.length}'),
                ),
                IconButton(
                  onPressed: () {
                    if (index < widget.picture.length) index++;
                    setState(() {});
                  },
                  iconSize: 27.0,
                  icon: const Icon(
                    Icons.arrow_circle_right_outlined,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
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
                  setState(() => _rotationTurns++);
                },
                iconSize: 27.0,
                icon: const Icon(
                  Icons.rotate_left,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() => _rotationTurns--);
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
      ),
    );
  }
}

class _CropAreaClipper extends CustomClipper<Path> {
  _CropAreaClipper(this.rect, this.radius);

  final Rect rect;
  final double radius;

  @override
  Path getClip(Size size) {
    return Path()
      ..addPath(
        Path()
          ..moveTo(rect.left, rect.top + radius)
          ..arcToPoint(Offset(rect.left + radius, rect.top),
              radius: Radius.circular(radius))
          ..lineTo(rect.right - radius, rect.top)
          ..arcToPoint(Offset(rect.right, rect.top + radius),
              radius: Radius.circular(radius))
          ..lineTo(rect.right, rect.bottom - radius)
          ..arcToPoint(Offset(rect.right - radius, rect.bottom),
              radius: Radius.circular(radius))
          ..lineTo(rect.left + radius, rect.bottom)
          ..arcToPoint(Offset(rect.left, rect.bottom - radius),
              radius: Radius.circular(radius))
          ..close(),
        Offset.zero,
      )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
