import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class CropImageHeaderWidget extends StatefulWidget {
  const CropImageHeaderWidget({Key? key, required this.listPictureHandle,}) : super(key: key);
  final List<File> listPictureHandle;

  @override
  State<CropImageHeaderWidget> createState() => _CropImageHeaderWidgetState();
}

class _CropImageHeaderWidgetState extends State<CropImageHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 5.0.h, right: 20.0, left: 20.0, bottom: 5.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              await deleteFile(context);
              Navigator.of(context).pop();
            },
            child: const Center(
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteFile(BuildContext context) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/handle_crop';
    Directory(tempPath).delete(recursive: true);
    // after delete file need delete imageCache to remove forever
    imageCache.clear();
    imageCache.clearLiveImages();
    widget.listPictureHandle.clear();
  }
}
