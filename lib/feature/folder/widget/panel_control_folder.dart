import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view/folder_trash_screen.dart';
import 'package:vart_tools/feature/folder/widget/bottom_sheet_sort.dart';
import 'package:vart_tools/feature/folder/widget/popup_folder.dart';
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
              builder: (context) =>
                  const PopUpFolder(title: "Tạo thư mục mới", folder: null),
            );
          },
          color: AppColors.grayColor,
          shape: const CircleBorder(),
          child: Image.asset(
            ResAssets.icons.newFolder,
            height: 30,
            width: 30,
          ),
        ),
        MaterialButton(
          height: 42,
          minWidth: 42,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  child: BottomSheetSort(),
                );
              },
            );
          },
          color: AppColors.grayColor,
          shape: const CircleBorder(),
          child: Image.asset(
            ResAssets.icons.sortFolder,
            height: 30,
            width: 30,
          ),
        ),
        MaterialButton(
          height: 42,
          minWidth: 42,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FolderTrashScreen()),
            );
          },
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
