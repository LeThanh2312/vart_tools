import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;
import 'package:opencv/opencv.dart';
import 'package:vart_tools/feature/camera/widgets/crop_image/show_image_transform.dart';

class CropImageWidget extends StatefulWidget {
  final Uint8List image;
  final double height;
  final double width;

  const CropImageWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.image,
  }) : super(key: key);

  @override
  State<CropImageWidget> createState() => _CropImageWidgetState();
}

class _CropImageWidgetState extends State<CropImageWidget> {
  List<Offset> points = [];
  double imgHeight = 0;
  double imgWidth = 0;
  double scale = 1;

  Color color(int i) {
    return [Colors.red, Colors.red, Colors.red, Colors.red][i];
  }

  void getImageSize() {
    final memoryImageSize =
        imgsize.ImageSizeGetter.getSize(imgsize.MemoryInput(widget.image));
    final imgHeightReal = memoryImageSize.width.toDouble();
    final imgWidthReal = memoryImageSize.height.toDouble();
    print('=== imgHeightReal ${imgHeightReal},${imgWidthReal}');
    imgHeight = imgHeightReal;
    imgWidth = imgWidthReal;

    double aspectRatioScreen = widget.height / widget.width;
    double aspectRatioImage = imgHeight / imgWidth;

    // if (aspectRatioImage == aspectRatioScreen) {
    //   imgHeight = widget.height;
    //   imgWidth = widget.width;
    // } else if (aspectRatioImage < aspectRatioScreen) {
    //   imgWidth = widget.width;
    //   imgHeight = imgWidth * aspectRatioImage;
    // } else {
    //   imgHeight = widget.height;
    //   imgWidth = imgHeight / aspectRatioImage;
    // }

    // 1

    imgWidth = widget.width;
    imgHeight = imgWidth * aspectRatioImage;

    if (imgHeight > widget.height) {
      imgHeight = widget.height;
      imgWidth = imgHeight / aspectRatioImage;
    }

    scale = imgHeightReal / imgHeight;

    points.add(Offset.zero);
    points.add(Offset(imgWidth, 0));
    points.add(Offset(imgWidth, imgHeight));
    points.add(Offset(0, imgHeight));
  }

  @override
  void initState() {
    getImageSize();
    super.initState();
  }

  void onPanUpdate(DragUpdateDetails details, int index) {
    final newPoint = Offset(
      points[index].dx + details.delta.dx,
      points[index].dy + details.delta.dy,
    );
    setState(() {
      points[index] = newPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      child: Stack(
        children: [
          SizedBox(
            width: imgWidth,
            height: imgHeight,
            child: Image.memory(
              widget.image,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            width: imgWidth,
            height: imgHeight,
          ),
          SizedBox(
            width: imgWidth,
            height: imgHeight,
            child: CustomPaint(
              painter: CustomCropImagePainter(points: points),
              size: Size(imgWidth, imgHeight),
              child: SizedBox(
                width: imgWidth,
                height: imgHeight,
              ),
            ),
          ),
          Positioned(
            left: points[0].dx,
            top: points[0].dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                onPanUpdate(details, 0);
              },
              child: CircleAvatar(
                radius: 6,
                backgroundColor: color(0),
              ),
            ),
          ),
          Positioned(
            left: points[1].dx - 12,
            top: points[1].dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                onPanUpdate(details, 1);
              },
              child: CircleAvatar(
                radius: 6,
                backgroundColor: color(2),
              ),
            ),
          ),
          Positioned(
            left: points[2].dx - 12,
            top: points[2].dy - 12,
            child: GestureDetector(
              onPanUpdate: (details) {
                onPanUpdate(details, 2);
              },
              child: CircleAvatar(
                radius: 6,
                backgroundColor: color(2),
              ),
            ),
          ),
          Positioned(
            left: points[3].dx,
            top: points[3].dy - 12,
            child: GestureDetector(
              onPanUpdate: (details) {
                onPanUpdate(details, 3);
              },
              child: CircleAvatar(
                radius: 6,
                backgroundColor: color(3),
              ),
            ),
          ),
          Positioned(
            left: widget.height / 2,
            top: widget.width / 2,
            child: IconButton(
              onPressed: () async {
                print('=== 0x ${points[0].dx.toInt() * scale.toInt()}');
                print('=== 0y ${points[0].dy.toInt() * scale.toInt()}');
                //
                print('=== 1x ${points[1].dx.toInt() * scale.toInt()}');
                print('=== 1y ${points[1].dy.toInt() * scale.toInt()}');
                //
                print('=== 2x ${points[2].dx.toInt() * scale.toInt()}');
                print('=== 2y ${points[2].dy.toInt() * scale.toInt()}');
                //
                print('=== 3x ${points[3].dx.toInt() * scale.toInt()}');
                print('=== 3y ${points[3].dy.toInt() * scale.toInt()}');

                Uint8List res = await ImgProc.warpPerspectiveTransform(
                  widget.image,
                  sourcePoints: [
                    points[0].dx.toInt() * scale.toInt(),
                    points[0].dy.toInt() * scale.toInt(),
                    //
                    points[1].dx.toInt() * scale.toInt(),
                    points[1].dy.toInt() * scale.toInt(),
                    //
                    points[3].dx.toInt() * scale.toInt(),
                    points[3].dy.toInt() * scale.toInt(),
                    //
                    points[2].dx.toInt() * scale.toInt(),
                    points[2].dy.toInt() * scale.toInt(),
                  ],
                  destinationPoints: [
                    0,
                    0,
                    //
                    612,
                    0,
                    //
                    0,
                    459,
                    //
                    612,
                    459,
                  ],
                  outputSize: [459, 612],
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ShowImageTransform(
                              image: res,
                            )));
              },
              icon: const Icon(Icons.add_circle),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCropImagePainter extends CustomPainter {
  List<Offset> points;

  CustomCropImagePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..strokeWidth = 2;

    var path = Path();
    path.moveTo(points[0].dx + 3, points[0].dy + 3);
    path.lineTo(points[1].dx - 3, points[1].dy + 3);
    path.lineTo(points[2].dx - 3, points[2].dy - 3);
    path.lineTo(points[3].dx + 3, points[3].dy - 3);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
