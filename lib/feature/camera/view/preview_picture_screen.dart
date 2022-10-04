import 'dart:io';
import 'dart:typed_data';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/enum/camera_type.dart';
import 'package:vart_tools/feature/camera/widgets/preview_picture/bottom_navigator_preview_widget.dart';
import '../../../common/enum/filter_item.dart';
import '../view_model/crop_picture_bloc.dart';
import '../widgets/preview_picture/popup_filter_image_widget.dart';
import '../widgets/preview_picture/preview_picture.dart';
import '../widgets/preview_picture/preview_picture_header.dart';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;
import 'package:opencv4/core/imgproc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _platformVersion = false;


  List<Uint8List> listPictureOrigin = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPlatformState();
      _copyFile();
    });

  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    String? platformVersion;
    try {
      platformVersion = await ImgProc.initOpenCV();
      _platformVersion = true;
      print(platformVersion);
    } catch (e) {
      platformVersion = '==== error ${e.toString()}';
    }
  }

  void _copyFile() async {
    for (var item in widget.listPicture) {
      var image = await item.readAsBytes();
      final memoryImageSize =
          imgsize.ImageSizeGetter.getSize(imgsize.MemoryInput(image));
      double imgHeightReal = memoryImageSize.height.toDouble();
      double imgWidthReal = memoryImageSize.width.toDouble();

      if (imgHeightReal < imgWidthReal) {
        final tmp = imgWidthReal;
        imgWidthReal = imgHeightReal;
        imgHeightReal = tmp;
        image = await ImgProc.rotate(image, 1);
      } else {
        image = image;
      }
      listPictureOrigin.add(image);
    }
    context.read<CameraPictureViewModel>().add(GetImageEvent(
        style: widget.style, pictureOrigin: listPictureOrigin, index: 1));
    setState(() {});
  }

  void onShowPopupFilter(bool value) {
    setState(() {
      isShowPopupFilter = !isShowPopupFilter;
    });
  }

  void onChangeImage(FilterItem value) {
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
              if (listPictureOrigin.isNotEmpty)
                PreviewPicture(
                  type: widget.style,
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
        child: PopupFilterImageWidget(
          onChangeImage: onChangeImage,
          isShowPopupFilter: isShowPopupFilter,
        ),
      ),
    );
  }
}
