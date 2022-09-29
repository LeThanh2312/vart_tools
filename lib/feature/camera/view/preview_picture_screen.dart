import 'dart:io';
import 'dart:typed_data';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/enum/camera_type.dart';
import 'package:vart_tools/feature/camera/widgets/preview_picture/bottom_navigator_preview_widget.dart';
import '../../../common/enum/filter_item.dart';
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

  List<Uint8List> listPictureOrigin = [];
  List<Uint8List> listPictureHandle = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _copyFile();
    });
  }

  void _copyFile() async {
    for (var item in widget.listPicture) {
      final image = await item.readAsBytes();
      listPictureOrigin.add(image);
      listPictureHandle.add(image);
    }
    setState(() {});
  }

  void onShowPopupFilter(bool value) {
    setState(() {
      isShowPopupFilter = !isShowPopupFilter;
    });
  }

  void onChangeImage(FilterItem value) {
    print('====== test');
    isShowPopupFilter = !isShowPopupFilter;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const PreviewPictureHeader(),
              if (listPictureHandle.isNotEmpty)
                PreviewPicture(
                  type: widget.style,
                  picture: listPictureHandle,
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
        listImage: widget.listPicture,
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
        child: PopupFilterImageWidget(
          listPictureOrigin: listPictureOrigin,
          listPictureHandle: listPictureHandle,
          onChangeImage: onChangeImage,
          isShowPopupFilter: isShowPopupFilter,
        ),
      ),
    );
  }
}
