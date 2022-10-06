import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../common/enum/filter_item.dart';
import '../../../../res/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/crop_picture_bloc.dart';

class PopupFilterImageWidget extends StatefulWidget {
  const PopupFilterImageWidget({
    Key? key,
    required this.onChangeImage,
    required this.isShowPopupFilter,
  }) : super(key: key);
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
      height: MediaQuery.of(context).size.height / 3,
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
        context
            .read<CameraPictureViewModel>()
            .add(FilterPictureEvent(filter: filter));
        widget.onChangeImage(filter);
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(filter.image),
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
      ),
    );
  }
}
