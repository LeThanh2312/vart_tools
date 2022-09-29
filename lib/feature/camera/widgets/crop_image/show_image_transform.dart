import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;


class ShowImageTransform extends StatefulWidget {
  const ShowImageTransform({
    Key? key,
    required this.image,
  }) : super(key: key);
  final Uint8List image;

  @override
  State<ShowImageTransform> createState() => _ShowImageTransformState();
}

class _ShowImageTransformState extends State<ShowImageTransform> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.blue,
          height: 95.0.h,
          width: 90.0.w,
          margin: EdgeInsets.all(10),
          child: Image.memory(
            widget.image,
            width: 70.0.w,
            fit: BoxFit.contain,
          ),
        )
    );
  }
}
