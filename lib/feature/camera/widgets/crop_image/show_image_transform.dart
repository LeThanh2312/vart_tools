import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.memory(
          widget.image,
          fit: BoxFit.scaleDown,
          width: 65.0.w,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
