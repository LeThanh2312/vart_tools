import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../../common/enum/camera_type.dart';

class CameraHeaderWidget extends StatefulWidget {
  const CameraHeaderWidget({
    Key? key,
    required this.styleCamera,
    required this.isPageFirst,
    required this.controller,
  }) : super(key: key);
  final CameraType styleCamera;
  final CameraController controller;
  final bool isPageFirst;

  @override
  State<CameraHeaderWidget> createState() => _CameraHeaderWidgetState();
}

class _CameraHeaderWidgetState extends State<CameraHeaderWidget> {
  bool isFlash = false;

  @override
  Widget build(BuildContext context) {
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
                if (!isFlash) {
                  widget.controller.setFlashMode(FlashMode.off);
                } else {
                  widget.controller.setFlashMode(FlashMode.always);
                }
                isFlash = !isFlash;
                setState(() {});
              },
              iconSize: 30,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(isFlash ? Icons.flash_on : Icons.flash_off,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
