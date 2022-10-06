import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;
import 'package:opencv4/core/imgproc.dart';
import 'package:vart_tools/feature/camera/view_model/crop_picture_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

double cropPointSize = 12;

class CropImageWidget extends StatefulWidget {
  final Uint8List image;
  final double height;
  final double width;
  final int index;
  final bool isRotate;

  const CropImageWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.image,
    required this.index,
    this.isRotate = true,
  }) : super(key: key);

  @override
  State<CropImageWidget> createState() => _CropImageWidgetState();
}

class _CropImageWidgetState extends State<CropImageWidget> {
  List<Offset> points = [];
  double imgHeight = 0;
  double imgWidth = 0;
  double scale = 1;
  Uint8List? image;
  Offset minOffset = const Offset(0.0,0.0);

  Color color(int i) {
    return [Colors.red, Colors.red, Colors.red, Colors.red][i];
  }

  void rotateImage() async {
    image = await ImgProc.rotate(widget.image, 0);
  }

  void getResize() {
    final memoryImageSize = imgsize.ImageSizeGetter.getSize(imgsize.MemoryInput(widget.image));
    double imgHeightReal = memoryImageSize.height.toDouble();
    double imgWidthReal = memoryImageSize.width.toDouble();

    image = widget.image;

    double aspectRatioScreen = widget.height / widget.width;
    double aspectRatioImage = imgHeightReal / imgWidthReal;

    if (aspectRatioImage < aspectRatioScreen) {
      imgWidth = widget.width;
      imgHeight = aspectRatioImage * imgWidth;
    } else {
      imgHeight = widget.height;
      imgWidth = imgHeight / aspectRatioImage;
    }

    scale = imgHeightReal / imgHeight;

    points.add(Offset.zero);
    points.add(Offset(imgWidth, 0));
    points.add(Offset(imgWidth, imgHeight));
    points.add(Offset(0, imgHeight));
    if(mounted) {
      context.read<CameraPictureViewModel>().add(GetPointsCropEvent(
          points: [points[0], points[1], points[2], points[3]], scale: scale));
      setState(() {});
    }
  }

  void getImageSize() {
    final memoryImageSize = imgsize.ImageSizeGetter.getSize(imgsize.MemoryInput(widget.image));
    double imgHeightReal = memoryImageSize.height.toDouble();
    double imgWidthReal = memoryImageSize.width.toDouble();

    if (imgHeightReal < imgWidthReal && widget.isRotate) {
      final tmp = imgWidthReal;
      imgWidthReal = imgHeightReal;
      imgHeightReal = tmp;
      rotateImage();
    } else {
      image = widget.image;
    }

    double aspectRatioScreen = widget.height / widget.width;
    double aspectRatioImage = imgHeightReal / imgWidthReal;

    if (aspectRatioImage < aspectRatioScreen) {
      imgWidth = widget.width;
      imgHeight = aspectRatioImage * imgWidth;
    } else {
      imgHeight = widget.height;
      imgWidth = imgHeight / aspectRatioImage;
    }

    scale = imgHeightReal / imgHeight;

    points.add(Offset.zero);
    points.add(Offset(imgWidth, 0));
    points.add(Offset(imgWidth, imgHeight));
    points.add(Offset(0, imgHeight));

    context.read<CameraPictureViewModel>().add(GetPointsCropEvent(points: [points[0],points[1],points[2],points[3]], scale: scale));
  }

  @override
  void initState() {
    super.initState();
    getImageSize();
    context.read<CameraPictureViewModel>().stream.listen((state) {
      if (state.isSuccess && state.isDoneRotate) {
        getImageSize();
      } else if(state.isPoints){
        points.clear();
        getResize();
      }
    });
  }

  void onPanUpdate(DragUpdateDetails details, int index) {
    if(index == 0 && (points[0].dx + details.delta.dx) > 0 && (points[0].dy + details.delta.dy) > 0){
      final newPoint = Offset(
        points[0].dx + details.delta.dx,
        points[0].dy + details.delta.dy,
      );
      setState(() {
        points[0] = newPoint;
      });
    }
    if(index == 1 &&(points[1].dx + details.delta.dx) < imgWidth && (points[1].dy + details.delta.dy) > 0){
      final newPoint = Offset(
        points[1].dx + details.delta.dx,
        points[1].dy + details.delta.dy,
      );
      setState(() {
        points[1] = newPoint;
      });
    }
    if(index == 2 && (points[2].dx + details.delta.dx) < imgWidth && (points[2].dy + details.delta.dy) < imgHeight){
      final newPoint = Offset(
        points[2].dx + details.delta.dx,
        points[2].dy + details.delta.dy,
      );
      setState(() {
        points[2] = newPoint;
      });
    }
    if(index == 3 && (points[3].dx + details.delta.dx) > 0 && (points[3].dy + details.delta.dy) < imgHeight){
      final newPoint = Offset(
        points[3].dx + details.delta.dx,
        points[3].dy + details.delta.dy,
      );
      setState(() {
        points[3] = newPoint;
      });
    }
    context.read<CameraPictureViewModel>().add(GetPointsCropEvent(points: [points[0],points[1],points[2],points[3]], scale: scale));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: imgWidth,
          height: imgHeight,
          child: Stack(
            children: [
              image != null
                  ? SizedBox(
                      width: imgWidth,
                      height: imgHeight,
                      child: Image.memory(
                        image!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
              SizedBox(
                width: imgWidth,
                height: imgHeight,
              ),
              IgnorePointer(
                child: ClipPath(
                  clipper: CustomCropImagePainter(points: points),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withAlpha(100),
                  ),
                ),
              ),
              Positioned(
                left: points[0].dx,
                top: points[0].dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                      print('====== ${details.delta.dx}, ${details.delta.dy}');
                      onPanUpdate(details, 0);
                  },
                  child: CircleAvatar(
                    radius: cropPointSize,
                    backgroundColor: color(0),
                  ),
                ),
              ),
              Positioned(
                left: points[1].dx - cropPointSize * 2,
                top: points[1].dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    onPanUpdate(details, 1);
                  },
                  child: CircleAvatar(
                    radius: cropPointSize,
                    backgroundColor: color(2),
                  ),
                ),
              ),
              Positioned(
                left: points[2].dx - cropPointSize * 2,
                top: points[2].dy - cropPointSize * 2,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    onPanUpdate(details, 2);
                  },
                  child: CircleAvatar(
                    radius: cropPointSize,
                    backgroundColor: color(2),
                  ),
                ),
              ),
              Positioned(
                left: points[3].dx,
                top: points[3].dy - cropPointSize * 2,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    onPanUpdate(details, 3);
                  },
                  child: CircleAvatar(
                    radius: cropPointSize,
                    backgroundColor: color(3),
                  ),
                ),
              ),
              ],
          ),
        ),
      ),
    );
  }
}

class CustomCropImagePainter extends CustomClipper<Path> {
  List<Offset> points;

  CustomCropImagePainter({required this.points});

  // @override
  // void paint(Canvas canvas, Size size) {
  //   final deltaSize = cropPointSize / 2;
  //   var paint = Paint()
  //     ..style = PaintingStyle.stroke
  //     ..color = Colors.white
  //     ..strokeWidth = 2;
  //
  //   var path = Path();
  //   path.moveTo(points[0].dx + deltaSize, points[0].dy + deltaSize);
  //   path.lineTo(points[1].dx - deltaSize, points[1].dy + deltaSize);
  //   path.lineTo(points[2].dx - deltaSize, points[2].dy - deltaSize);
  //   path.lineTo(points[3].dx + deltaSize, points[3].dy - deltaSize);
  //   path.close();
  //   canvas.drawPath(path, paint);
  // }
  //
  // @override
  // bool shouldRepaint(covariant CustomPainter oldDelegate) {
  //   return true;
  // }

  @override
  Path getClip(Size size) {
    final deltaSize = cropPointSize / 2;
    var paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white
        ..strokeWidth = 2;

    var path = Path()
        ..addPath(
          Path()
            ..moveTo(points[0].dx + deltaSize, points[0].dy + deltaSize)
            ..lineTo(points[1].dx - deltaSize, points[1].dy + deltaSize)
            ..lineTo(points[2].dx - deltaSize, points[2].dy - deltaSize)
            ..lineTo(points[3].dx + deltaSize, points[3].dy - deltaSize)
            ..close(),
          Offset.zero,
        )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
