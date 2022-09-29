import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/enum/camera_type.dart';
import 'package:vart_tools/feature/camera/view_model/camera_bloc.dart';

class PreviewPicture extends StatefulWidget {
  const PreviewPicture({
    Key? key,
    required this.type,
    required this.picture,
  }) : super(key: key);
  final CameraType type;
  final List<Uint8List> picture;

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
                    Image.memory(widget.picture[0],
                        fit: BoxFit.cover, width: 100),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.memory(widget.picture[1],
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
                  int index = widget.picture.indexOf(e);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _numbered((index + 1).toString()),
                      Container(
                        margin:
                        const EdgeInsets.only(bottom: 10, left: 10),
                        child: Image.memory(
                          widget.picture[index],
                          fit: BoxFit.cover,
                          width: 30.0.w,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )
            ),
    );
  }

  Widget _numbered(String text) {
    return Text(
      text.length == 1 ? '0$text' : text,
    );
  }
}
