import 'package:flutter/material.dart';
import 'package:vart_tools/res/app_color.dart';

class BottomSheetIconMore extends StatelessWidget {
  const BottomSheetIconMore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 10,
            bottom: 10,
          ),
          child: Text(
            "Thuỳ dung",
            style: TextStyle(
              backgroundColor: AppColors.grayColor,
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Rename",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                )),
            Icon(Icons.edit)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Yêu thích",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                )),
            Icon(Icons.favorite_border),
          ],
        ),
        Row(
          children: const [
            Text("Xoá",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                )),
            Icon(Icons.delete),
          ],
        )
      ],
    );
  }
}
