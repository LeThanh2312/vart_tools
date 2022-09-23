import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:extended_image_library/extended_image_library.dart';
import 'package:image/image.dart' as ImageLib;
import '../../../common/crop_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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
  List<File> listPicture = [];

  int index = 1;
  final GlobalKey _cropperKey = GlobalKey(debugLabel: 'cropperKey');

  //late Rect _rect;
  final _cropController = CropController();
  bool isRotating = false;
  @override
  void initState() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/test';
    for(var item in widget.listPictureOrigin) {
      try {
        listPicture.add(item);
      } catch(err) {
        // Do something here
      }
    }    super.initState();
  }
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
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: isRotating
                      ? const CircularProgressIndicator()
                      : Image.file(
                          listPicture[index - 1],
                          fit: BoxFit.cover,
                          width: 60.0.w,
                          alignment: Alignment.topCenter,
                        ),
                ),
                // IgnorePointer(
                //   child: ClipPath(
                //     clipper:_CropAreaClipper(_rect, 0),
                //     child: Container(
                //       width: double.infinity,
                //       height: double.infinity,
                //       color:  Colors.black.withAlpha(100),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 68.0.h,
          //   child: Crop(
          //     image: File(widget.picture[index - 1].path).readAsBytesSync(),
          //     controller: _cropController,
          //     onCropped: (image) {
          //     },
          //     rotationTurns: _rotationTurns,
          //   ),
          // ),
          //
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
                  child: Text('$index/${listPicture.length}'),
                ),
                IconButton(
                  onPressed: () {
                    if (index < listPicture.length) index++;
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
                  setState(() {});
                  _rotateImage(listPicture[index - 1], 90);
                },
                iconSize: 27.0,
                icon: const Icon(
                  Icons.rotate_left,
                ),
              ),
              IconButton(
                onPressed: () {
                  _rotateImage(listPicture[index - 1], -90);
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
      ),
    );
  }

  void _rotateImage(File file, int angle) async {
    setState(() {
      isRotating = true;
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
      final selectedFile = listPicture[index - 1];
      final newFile = await selectedFile.writeAsBytes(ImageLib.encodeJpg(contrast));
      listPicture[index - 1] = newFile;
      imageCache.clear();
      imageCache.clearLiveImages();
      setState(() {});
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isRotating = false;
      });
    }
  }
}