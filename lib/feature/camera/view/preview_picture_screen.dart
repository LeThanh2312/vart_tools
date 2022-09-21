import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/enum/camera_type.dart';
import 'package:vart_tools/feature/camera/widgets/preview_picture/bottom_navigator_preview_widget.dart';
import '../widgets/preview_picture/popup_filter_image_widget.dart';
import '../widgets/preview_picture/preview_picture.dart';
import '../widgets/preview_picture/preview_picture_header.dart';

class PreviewPictureScreen extends StatefulWidget {
  const PreviewPictureScreen({
    Key? key,
    required this.listPicture,
    required this.style,
  }) : super(key: key);
  final List<File> listPicture;
  final CameraType style;

  @override
  State<PreviewPictureScreen> createState() => _PreviewPictureScreenState();
}

class _PreviewPictureScreenState extends State<PreviewPictureScreen> {
  bool isShowPopupFilter = false;

  void onShowPopupFilter(bool value) {
    setState(() {
      isShowPopupFilter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const PreviewPictureHeader(),
              if (widget.listPicture.isNotEmpty)
                PreviewPicture(
                  type: widget.style,
                  picture: widget.listPicture,
                )
              else
                Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
          showPopupFilter(),
        ],
      ),
      bottomNavigationBar: BottomNavigatorPreviewWidget(
        onShowPopupFilter: onShowPopupFilter,
      ),
    );
  }

  Widget showPopupFilter() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: isShowPopupFilter ? 100.0.w : 0,
        height: isShowPopupFilter ? 40.0.h : 0,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(isShowPopupFilter ? 0.0 : 300.0),
            color: Colors.transparent),
        child: const PopupFilterImageWidget(),
      ),
    );
  }
}
