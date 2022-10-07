import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/animation/scale_animation.dart';
import 'package:vart_tools/common/enum/camera_type.dart';
import 'package:vart_tools/common/enum/save_picture_type.dart';
import 'package:vart_tools/common/enum/tab_item.dart';
import 'package:vart_tools/feature/camera/view_model/save_picture_bloc.dart';
import '../../../bottom_navigation_bar_main/view/bottom_navigation_bar_main_screen.dart';
import '../../view/crop_image_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../view_model/crop_picture_bloc.dart';
import 'package:synchronized/synchronized.dart';


class BottomNavigatorPreviewWidget extends StatefulWidget {
  const BottomNavigatorPreviewWidget({
    Key? key,
    required this.onShowPopupFilter,
    required this.style,
  }) : super(key: key);
  final void Function(bool value) onShowPopupFilter;
  final CameraType style;

  @override
  State<BottomNavigatorPreviewWidget> createState() =>
      _BottomNavigatorPreviewWidgetState();
}

class _BottomNavigatorPreviewWidgetState
    extends State<BottomNavigatorPreviewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  SlideRightRoute(page: const CropImageScreen())
                );
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.crop,
              ),
            ),
            IconButton(
              onPressed: () {
                widget.onShowPopupFilter(true);
                setState(() {});
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.filter_alt_rounded,
              ),
            ),
            IconButton(
              onPressed: () {
                _showDialogSelectFolder();
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.check,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFileLocalStorage(List<Uint8List> pictureCrop,
      String tempPath, SavePictureType type, int size,String name) async {
    context.read<SavePictureViewModel>().add(
          SaveEvent(
              style: widget.style,
              listPictureSave: pictureCrop,
              savePictureType: type,
              tempPath: tempPath,
              size: size,
              name: name,
          ),
        );
  }

  Future<void> _showDialogSelectFolder() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Bạn muốn lưu files vào đâu ?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                SavePictureType.create.name,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final state = context.read<CameraPictureViewModel>().state;
                Directory tempDir = await getTemporaryDirectory();
                String tempPath = '${tempDir.path}/vars_tools';
                Directory(tempPath).create();
                String name = 'camera_${DateTime.now()}.jpg';
                if (state.isSuccess) {
                  _saveFileLocalStorage(state.pictureCrop, tempPath,
                          SavePictureType.create, 0,name)
                      .then((value) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavigationBarMainScreen(
                                          currentTab: TabItem.file)),
                            )
                          });
                }

              },
            ),
            ElevatedButton(
              child: Text(
                SavePictureType.selector.name,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Directory tempDir = await getTemporaryDirectory();
                String tempPath = '${tempDir.path}/vars_tools';
                Directory(tempPath).create();
                final state = context.read<CameraPictureViewModel>().state;
                if (state.isSuccess) {
                  _saveFileLocalStorage(state.pictureCrop, tempPath,
                          SavePictureType.selector, 0,'')
                      .then((value) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavigationBarMainScreen(
                                          currentTab: TabItem.file)),
                            ),
                          });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
