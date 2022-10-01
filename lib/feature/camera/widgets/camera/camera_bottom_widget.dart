// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:camera/camera.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../../common/enum/camera_type.dart';
import '../../../../res/vietnam_asset_picker_text_delegate.dart';
import '../../view/list_picture_photo_screen.dart';
import '../../view/preview_picture_screen.dart';

class CameraBottomWidget extends StatefulWidget {
  const CameraBottomWidget(
    this.onChangeType,
    this.onChangePageFirst, {
    Key? key,
    required this.styleCamera,
    required this.controller,
    required this.isPageFirst,
  }) : super(key: key);
  final CameraType styleCamera;
  final CameraController controller;
  final bool isPageFirst;
  final void Function(CameraType value) onChangeType;
  final void Function(bool value) onChangePageFirst;

  @override
  State<CameraBottomWidget> createState() => _CameraBottomWidgetState();
}

class _CameraBottomWidgetState extends State<CameraBottomWidget> {
  List<File> listPicture = [];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 13.0.h,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            color: Colors.transparent),
        child: Column(
          children: [
            SizedBox(
              height: 2.0.h,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: CameraType.values.map(
                  (CameraType e) {
                    return InkWell(
                      onTap: () {
                        if (listPicture.isEmpty || widget.styleCamera == e) {
                          widget.onChangeType(e);
                        } else {
                          _showDialogMoveStyleCamera(e);
                        }
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Text(
                            e.name,
                            style: TextStyle(
                              color: widget.styleCamera == e
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      takePicture(context);
                    },
                    iconSize: 50,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.camera, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: (listPicture.isNotEmpty &&
                          (widget.styleCamera == CameraType.passport ||
                              widget.styleCamera == CameraType.document))
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListPicturePhotoScreen(
                                  listPicture: listPicture,
                                  style: widget.styleCamera,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.file(
                                  File(listPicture.last.path),
                                  fit: BoxFit.cover,
                                  width: 40,
                                ),
                                Positioned(
                                  right: 8.0.w,
                                  top: 0,
                                  child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      child: Text('${listPicture.length}/20')),
                                ),
                              ],
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: () async {
                            getImageGallery(context);
                          },
                          iconSize: 50,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.collections,
                              color: Colors.black),
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialogMoveStyleCamera(CameraType style) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: RichText(
            text: const TextSpan(
              text: 'Bạn muốn dừng thao tác ? \n',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'ảnh của bạn sẽ không được lưu lại',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(
                'Đồng ý',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                listPicture.clear();
                widget.onChangeType(style);
                widget.onChangePageFirst(true);
                setState(() {});
              },
            ),
            ElevatedButton(
              child: const Text(
                'Hủy',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future takePicture(BuildContext context) async {
    XFile? pictureBefore;
    XFile? pictureAfter;
    if (!widget.controller.value.isInitialized) {
      return null;
    }
    if (widget.controller.value.isTakingPicture) {
      return null;
    }
    if (widget.styleCamera == CameraType.cardID) {
      if (widget.isPageFirst) {
        pictureBefore = await widget.controller.takePicture();
        listPicture.add(File(pictureBefore.path));
        widget.onChangePageFirst(false);
        setState(() {});
      } else {
        pictureAfter = await widget.controller.takePicture();
        listPicture.add(File(pictureAfter.path));
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewPictureScreen(
              listPicture: listPicture,
              style: CameraType.cardID,
            ),
          ),
        ).then(
          (_) => setState(
            () {
              listPicture.clear();
              widget.onChangePageFirst(true);
            },
          ),
        );
      }
    } else if (widget.styleCamera == CameraType.passport ||
        widget.styleCamera == CameraType.document) {
      try {
        await widget.controller.setFlashMode(FlashMode.off);
        pictureBefore = await widget.controller.takePicture();
        if (listPicture.length < 20) {
          listPicture.add(File(pictureBefore.path));
        }
        setState(() {});
      } on CameraException catch (e) {
        debugPrint('Error occured while taking pictureBefore: $e');
        return null;
      }
    } else {}
  }

  Future<void> getImageGallery(BuildContext context) async {
    List<AssetEntity>? resultList = [];

    resultList = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: widget.styleCamera == CameraType.cardID ? 2 : 20,
        themeColor: Colors.orangeAccent,
        textDelegate: const VietnameseAssetPickerTextDelegate(),
      ),
    );

    if (resultList != null) {
      for (var item in resultList) {
        try {
          final file = await item.file;
          listPicture.add(file!);
        } catch (err) {
          // Do something here
        }
      }
      if (widget.styleCamera == CameraType.cardID && listPicture.length != 2) {
        const snackBar = SnackBar(
          content: Text('Vui lòng chọn ít nhất hai ảnh'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        listPicture.clear();
      } else {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewPictureScreen(
              listPicture: listPicture,
              style: widget.styleCamera,
            ),
          ),
        ).then(
          (_) => setState(
            () {
              listPicture.clear();
              widget.onChangePageFirst(true);
            },
          ),
        );
      }
    } else {}
  }
}
