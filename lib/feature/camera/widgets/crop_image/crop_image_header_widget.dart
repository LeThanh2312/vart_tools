import 'dart:typed_data';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/crop_picture_bloc.dart';

class CropImageHeaderWidget extends StatefulWidget {
  const CropImageHeaderWidget({Key? key}) : super(key: key);

  @override
  State<CropImageHeaderWidget> createState() => _CropImageHeaderWidgetState();
}

class _CropImageHeaderWidgetState extends State<CropImageHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 5.0.h, right: 20.0, left: 20.0, bottom: 5.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              imageCache.clear();
              imageCache.clearLiveImages();
              context.read<CameraPictureViewModel>().add(ResetListImageEvent());
              Navigator.of(context).pop();
            },
            child: const Center(
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ],
      ),
    );
  }
}
