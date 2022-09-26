import 'package:flutter/material.dart';
import '../../../res/app_color.dart';
import 'package:sizer/sizer.dart';
import '../../../res/app_constants.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchWardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: AppColors.greyLine)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 0, right: defaultPadding),
          child: TextField(
            autofocus: false,
            onChanged: (String value) {},
            controller: searchWardController,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm',
              hintStyle: TextStyle(
                color: Color(0xFF717171),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              //contentPadding: EdgeInsets.only(bottom: 2.0.h),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search,color: Colors.blue,),
            ),
          ),
        ),
      ),
    );
  }
}
