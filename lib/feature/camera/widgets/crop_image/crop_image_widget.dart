import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;
import 'package:opencv/opencv.dart';
import 'package:vart_tools/feature/camera/view_model/crop_picture_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

double cropPointSize = 12;

class CropImageWidget extends StatefulWidget {
  final Uint8List image;
  final double height;
  final double width;
  final int index;

  const CropImageWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.image,
    required this.index,
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

  Color color(int i) {
    return [Colors.red, Colors.red, Colors.red, Colors.red][i];
  }

  void rotateImage() async {
    image = await ImgProc.rotate(widget.image, 90);
    setState(() {});
  }

  void getImageSize() {
    BlocListener<CameraPictureViewModel, CropAndFilterPictureState>(
        listener: (context, state) {
            image = state.pictureCrop[state.index - 1];
        }
    );

    print('======== image 2 $image');
    final memoryImageSize =
        imgsize.ImageSizeGetter.getSize(imgsize.MemoryInput(widget.image));
    double imgHeightReal = memoryImageSize.height.toDouble();
    double imgWidthReal = memoryImageSize.width.toDouble();

    if (imgHeightReal < imgWidthReal) {
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
  }

  void onPanUpdate(DragUpdateDetails details, int index) {
    final newPoint = Offset(
      points[index].dx + details.delta.dx,
      points[index].dy + details.delta.dy,
    );
    setState(() {
      points[index] = newPoint;
    });
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

class CustomCropImagePainter extends CustomPainter {
  List<Offset> points;

  CustomCropImagePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final deltaSize = cropPointSize / 2;
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..strokeWidth = 2;

    var path = Path();
    path.moveTo(points[0].dx + deltaSize, points[0].dy + deltaSize);
    path.lineTo(points[1].dx - deltaSize, points[1].dy + deltaSize);
    path.lineTo(points[2].dx - deltaSize, points[2].dy - deltaSize);
    path.lineTo(points[3].dx + deltaSize, points[3].dy - deltaSize);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
