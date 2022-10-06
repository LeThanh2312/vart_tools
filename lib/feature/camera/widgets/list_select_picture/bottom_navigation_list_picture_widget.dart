import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/animation/scale_animation.dart';
import '../../../../common/enum/camera_type.dart';
import '../../view/preview_picture_screen.dart';

class BottomNavigatorListPictureWidget extends StatefulWidget {
  const BottomNavigatorListPictureWidget({
    Key? key,
    required this.type,
    required this.listPicture,
    required this.listPictureRemove,
  }) : super(key: key);

  final CameraType type;
  final List<File> listPicture;
  final List<File> listPictureRemove;

  @override
  State<BottomNavigatorListPictureWidget> createState() =>
      _BottomNavigatorListPictureWidgetState();
}

class _BottomNavigatorListPictureWidgetState
    extends State<BottomNavigatorListPictureWidget> {
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
            const SizedBox(
              width: 27.0,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.camera_alt,
              ),
            ),
            //to leave space in between the bottom app bar items and below the FAB
            IconButton(
              onPressed: () async {
                await listPictureSelect();
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

  Future<List<File>> listPictureSelect() async {
    List<File> listPictureSelect = [...widget.listPicture];
    for (var item in widget.listPictureRemove) {
      try {
        listPictureSelect.remove(item);
      } catch (err) {
        // Do something here
      }
    }
    if (listPictureSelect.isNotEmpty) {
      Navigator.push(
          context,
          SlideRightRoute(
            page: PreviewPictureScreen(
              listPicture: listPictureSelect,
              style: widget.type,
            ),
          ));
    } else {
      const snackBar = SnackBar(
        content: Text('Vui lòng chọn ít nhất một ảnh'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return listPictureSelect;
  }
}
