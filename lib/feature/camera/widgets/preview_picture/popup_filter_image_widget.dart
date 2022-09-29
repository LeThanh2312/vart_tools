import 'dart:typed_data';
import 'package:opencv/opencv.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../common/enum/filter_item.dart';
import '../../../../res/app_color.dart';
import 'package:opencv/core/core.dart';

class PopupFilterImageWidget extends StatefulWidget {
  const PopupFilterImageWidget({
    Key? key,
    required this.listPictureOrigin,
    required this.onChangeImage,
    required this.listPictureHandle, required this.isShowPopupFilter,
  }) : super(key: key);
  final List<Uint8List> listPictureOrigin;
  final List<Uint8List> listPictureHandle;
  final void Function(FilterItem value) onChangeImage;
  final bool isShowPopupFilter;


  @override
  State<PopupFilterImageWidget> createState() => _PopupFilterImageWidgetState();
}

class _PopupFilterImageWidgetState extends State<PopupFilterImageWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0.w,
      height: 40.0.h,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColors.greyLine),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: FilterItem.values.length,
        itemBuilder: (BuildContext ctx, int index) {
          return filterItem(context, FilterItem.values[index]);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 5.0.h / 4.5.h,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0),
      ),
    );
  }

  Widget filterItem(BuildContext context, FilterItem filter) {
    return InkWell(
      onTap: () async {
        widget.listPictureHandle.clear();
        widget.listPictureHandle.addAll(widget.listPictureOrigin);
        if (filter == FilterItem.blur) {
          for (var item in widget.listPictureHandle) {
            Uint8List res = await ImgProc.blur(item, [45, 45], [20, 30], Core.borderReflect) as Uint8List;
            widget.listPictureHandle[widget.listPictureHandle.indexOf(item)] = res;
          }
          widget.onChangeImage(FilterItem.blur);
        } else if (filter == FilterItem.shadows) {
          for (var item in widget.listPictureHandle) {
            Uint8List res = await ImgProc.grayScale(item) as Uint8List;
            widget.listPictureHandle[widget.listPictureHandle.indexOf(item)] = res;
          }
          widget.onChangeImage(FilterItem.shadows);
        } else if (filter == FilterItem.fullAngle) {
          widget.onChangeImage(FilterItem.fullAngle);
        } else if (filter == FilterItem.brighten) {

        } else if (filter == FilterItem.ecological) {

        } else if (filter == FilterItem.bVW) {
          for (var item in widget.listPictureHandle) {
            Uint8List res = await ImgProc.adaptiveThreshold(item, 125,
                ImgProc.adaptiveThreshMeanC, ImgProc.threshBinary, 11, 12) as Uint8List;
            widget.listPictureHandle[widget.listPictureHandle.indexOf(item)] = res;
          }
          widget.onChangeImage(FilterItem.bVW);
        } else {}
      },
      child: Column(
        children: [
          Container(
            width: 18.0.w,
            height: 18.0.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            filter.name,
          ),
        ],
      ),
    );
  }

}

