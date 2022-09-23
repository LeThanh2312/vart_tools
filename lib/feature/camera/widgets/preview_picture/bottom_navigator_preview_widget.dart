import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../view/crop_image_screen.dart';

class BottomNavigatorPreviewWidget extends StatefulWidget {
  const BottomNavigatorPreviewWidget({
    Key? key,
    required this.onShowPopupFilter,
    required this.listImage,
  }) : super(key: key);
  final void Function(bool value) onShowPopupFilter;
  final List<File> listImage;

  @override
  State<BottomNavigatorPreviewWidget> createState() =>
      _BottomNavigatorPreviewWidgetState();
}

class _BottomNavigatorPreviewWidgetState
    extends State<BottomNavigatorPreviewWidget> {
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
              onPressed: () async{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CropImageScreen(
                      listPictureOrigin: widget.listImage,
                    ),
                  ),
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
            //to leave space in between the bottom app bar items and below the FAB
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

  Future<void> _showDialogSelectFolder() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Bạn muốn lưu files vào đâu ?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(
                'Thư mục mới',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text(
                'Chọn thư mục',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (contextMain) =>
                //     const BottomBarMainScreen(indexTabItem: TabItem.file),
                //   ),
                //   ModalRoute.withName('/'),
                // );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
