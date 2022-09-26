import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vart_tools/common/enum/camera_type.dart';
import 'package:vart_tools/feature/camera/widgets/list_select_picture/gridview_image_widget.dart';

import '../widgets/list_select_picture/bottom_navigation_list_picture_widget.dart';

class ListPicturePhotoScreen extends StatefulWidget {
  const ListPicturePhotoScreen({
    Key? key,
    required this.listPicture,
    required this.style,
  }) : super(key: key);
  final List<File> listPicture;
  final CameraType style;

  @override
  State<ListPicturePhotoScreen> createState() => _ListPicturePhotoScreenState();
}

class _ListPicturePhotoScreenState extends State<ListPicturePhotoScreen> {
  late List<File> listPictureRemove = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: 5.0.h,
          right: 20.0,
          left: 20.0,
          bottom: 5.0.w,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridviewImageWidget(
                  listPicture: widget.listPicture,
                  listPictureRemove: listPictureRemove),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorListPictureWidget(
        type: widget.style,
        listPicture: widget.listPicture,
        listPictureRemove: listPictureRemove,
      ),
    );
  }
}
