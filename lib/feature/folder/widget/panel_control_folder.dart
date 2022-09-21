import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vart_tools/feature/folder/widget/popup_new_folder.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/assets.dart';

class PanelControlFolder extends StatelessWidget {
  const PanelControlFolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Tất cả 2",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        MaterialButton(
          height: 42,
          minWidth: 42,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const PopupNewFolder(),
            );
          },
          color: AppColors.grayColor,
          shape: const CircleBorder(),
          child: Image.asset(
            ResAssets.icons.new_folder,
            height: 30,
            width: 30,
          ),
        ),
        MaterialButton(
          height: 42,
          minWidth: 42,
          onPressed: () {},
          color: AppColors.grayColor,
          shape: const CircleBorder(),
          child: Image.asset(
            ResAssets.icons.sort_folder,
            height: 30,
            width: 30,
          ),
        ),
        MaterialButton(
          height: 42,
          minWidth: 42,
          onPressed: () {},
          color: AppColors.grayColor,
          shape: const CircleBorder(),
          child: Image.asset(
            ResAssets.icons.delete,
            height: 30,
            width: 30,
          ),
        ),
      ],
    );
  }
}
