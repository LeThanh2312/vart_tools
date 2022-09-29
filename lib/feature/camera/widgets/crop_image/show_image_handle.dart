import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vart_tools/feature/camera/widgets/crop_image/crop_image_widget.dart';

class ShowImageHandle extends StatefulWidget {
  const ShowImageHandle({
    Key? key,
    required this.listPictureHandle,
    required this.isRotating,
    required this.index,
    required this.onChangeIndex,
  }) : super(key: key);
  final List<Uint8List> listPictureHandle;
  final bool isRotating;
  final int index;
  final void Function(int value) onChangeIndex;

  @override
  State<ShowImageHandle> createState() => _ShowImageHandleState();
}

class _ShowImageHandleState extends State<ShowImageHandle> {
  late Rect _rect;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: widget.isRotating
                ? const CircularProgressIndicator()
                :
                // Image.memory(
                //     widget.listPictureHandle[widget.index - 1],
                //     fit: BoxFit.cover,
                //     width: 65.0.w,
                //     alignment: Alignment.topCenter,
                //   ),
                CropImageWidget(
                    image: widget.listPictureHandle[widget.index - 1],
                    height: MediaQuery.of(context).size.height - 230,
                    width: MediaQuery.of(context).size.width,
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.index > 1)
                        widget.onChangeIndex(widget.index - 1);
                      setState(() {});
                    },
                    iconSize: 27.0,
                    icon: const Icon(
                      Icons.arrow_circle_left_outlined,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        '${widget.index}/${widget.listPictureHandle.length}'),
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget.index < widget.listPictureHandle.length)
                        widget.onChangeIndex(widget.index + 1);
                      setState(() {});
                    },
                    iconSize: 27.0,
                    icon: const Icon(
                      Icons.arrow_circle_right_outlined,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}