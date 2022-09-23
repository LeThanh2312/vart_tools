import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/widget/popup_confirm_delete_folder.dart';
import 'package:vart_tools/feature/folder/widget/popup_folder.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';

class BottomSheetFolder extends StatelessWidget {
  const BottomSheetFolder({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                color: AppColors.grayColor,
                padding: const EdgeInsets.only(top: 5, left: 20, bottom: 5),
                child: const Text(
                  "Thuỳ dung",
                  style: ResStyle.h6,
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  PopUpFolder(title: "sửa thư mục", folderId: folder.id),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Rename",
                  style: ResStyle.h6,
                ),
                Icon(Icons.edit)
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Yêu thích",
                style: ResStyle.h6,
              ),
              Icon(Icons.favorite_border),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => PopupConfirmDeleteFolder(folder: folder),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Xoá",
                  style: ResStyle.h6,
                ),
                Icon(Icons.delete),
              ],
            ),
          ),
        )
      ],
    );
  }
}
