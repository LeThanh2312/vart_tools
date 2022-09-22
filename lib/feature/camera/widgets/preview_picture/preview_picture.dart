import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/enum/camera_type.dart';

class PreviewPicture extends StatefulWidget {
  const PreviewPicture({
    Key? key,
    required this.type,
    required this.picture,
  }) : super(key: key);
  final CameraType type;
  final List<File> picture;

  @override
  State<PreviewPicture> createState() => _PreviewPictureState();
}

class _PreviewPictureState extends State<PreviewPicture> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.type == CameraType.cardID
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _numbered('1'),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.file(File(widget.picture[0].path),
                        fit: BoxFit.cover, width: 100),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.file(File(widget.picture[1].path),
                        fit: BoxFit.cover, width: 100),
                  ],
                ),
              ],
            )
          : Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: widget.picture.map((e) {
                  String index = '${widget.picture.indexOf(e) + 1}';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _numbered(index),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10,left: 10),
                        child: Image.file(File(e.path),
                            fit: BoxFit.cover, width: 30.0.w),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _numbered(String text) {
    return Text(
      text.length == 1 ? '0$text' : text,
    );
  }
}
