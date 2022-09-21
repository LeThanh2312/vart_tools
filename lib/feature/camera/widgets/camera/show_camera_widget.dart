import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_dash/flutter_dash.dart';
import '../../../../common/enum/camera_type.dart';

class ShowCameraWidget extends StatefulWidget {
  const ShowCameraWidget({Key? key, required this.styleCamera, required this.controller})
      : super(key: key);
  final CameraType styleCamera;
  final CameraController controller;

  @override
  State<ShowCameraWidget> createState() => _ShowCameraWidgetState();
}

class _ShowCameraWidgetState extends State<ShowCameraWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 9.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.styleCamera == CameraType.cardID)
            Expanded(child: customCameraIDCard()),
          if (widget.styleCamera == CameraType.passport)
            Expanded(child: customCameraPassport()),
          if (widget.styleCamera == CameraType.document)
            Expanded(child: customCameraDocument()),
        ],
      ),
    );
  }

  Widget customCameraIDCard() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 70.0.h,
          child: CameraPreview(widget.controller),
        ),
      ],
    );
  }

  Widget customCameraPassport() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 70.0.h,
          child: CameraPreview(widget.controller),
        ),
        SizedBox(
          height: 70.0.h,
          child: const Center(
            child: Dash(
                direction: Axis.horizontal,
                length: 400,
                dashLength: 12,
                dashColor: Colors.black),
          ),
        )
      ],
    );
  }

  Widget customCameraDocument() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 70.0.h,
          child: CameraPreview(widget.controller),
        ),
      ],
    );
  }
}
