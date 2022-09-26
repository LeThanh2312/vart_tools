import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../common/enum/filter_item.dart';
import '../../../../res/app_color.dart';

class PopupFilterImageWidget extends StatefulWidget {
  const PopupFilterImageWidget({Key? key}) : super(key: key);

  @override
  State<PopupFilterImageWidget> createState() => _PopupFilterImageWidgetState();
}

class _PopupFilterImageWidgetState extends State<PopupFilterImageWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0.w,
      height: 40.0.h,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColors.greyLine),
        borderRadius: BorderRadius.circular(15),
        color: Colors.black,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: FilterItem.values.length,
        itemBuilder: (BuildContext ctx, int index) {
          return filterItem(FilterItem.values[index]);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 5.0.h / 4.5.h,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0),
      ),
    );
  }

  Widget filterItem(FilterItem filter) {
    return InkWell(
      onTap: (){
        if(filter ==  FilterItem.blur){

        }else if(filter ==  FilterItem.shadows){

        }else if(filter ==  FilterItem.fullAngle){

        }else if(filter ==  FilterItem.brighten){

        }else if(filter ==  FilterItem.ecological){

        }else if(filter ==  FilterItem.bVW){

        }else{

        }
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
