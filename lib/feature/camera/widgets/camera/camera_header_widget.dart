import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../../common/enum/camera_type.dart';

class CameraHeaderWidget extends StatefulWidget {
  const CameraHeaderWidget({
    Key? key,
    required this.styleCamera,
    required this.isPageFirst,
    required this.controller,
    required this.isFlash,
    required this.onChangeFlash,
  }) : super(key: key);
  final CameraType styleCamera;
  final CameraController controller;
  final bool isPageFirst;
  final bool isFlash;
  final void Function(bool value) onChangeFlash;

  @override
  State<CameraHeaderWidget> createState() => _CameraHeaderWidgetState();
}

class _CameraHeaderWidgetState extends State<CameraHeaderWidget> {

  @override
  Widget build(BuildContext context) {
    print('====== ${widget.isFlash}');
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 0, right: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 30,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.close, color: Colors.black),
            ),
            Visibility(
              visible: (widget.styleCamera == CameraType.cardID),
              child: Text(
                widget.isPageFirst ? 'Trang đầu' : 'Trang sau',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              onPressed: () {
                widget.onChangeFlash(!widget.isFlash);
                setState(() {});
              },
              iconSize: 30,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(widget.isFlash ? Icons.flash_on : Icons.flash_off ,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
