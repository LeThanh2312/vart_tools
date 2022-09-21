import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../common/enum/camera_type.dart';
import '../../view/preview_picture_screen.dart';

class BottomNavigatorListPictureWidget extends StatefulWidget {
  const BottomNavigatorListPictureWidget({
    Key? key,
    required this.type,
    required this.listPicture,
  }) : super(key: key);
  final CameraType type;
  final List<File> listPicture;

  @override
  State<BottomNavigatorListPictureWidget> createState() =>
      _BottomNavigatorListPictureWidgetState();
}

class _BottomNavigatorListPictureWidgetState extends State<BottomNavigatorListPictureWidget> {

  late final List<File> listPictureAfterSelect;



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
                setState(() {});
              },
              iconSize: 27.0,
              icon: const Icon(
                Icons.camera_alt,
              ),
            ),
            //to leave space in between the bottom app bar items and below the FAB
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewPictureScreen(
                      listPicture: widget.listPicture,
                      style: widget.type,
                    ),
                  ),
                );
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
}
