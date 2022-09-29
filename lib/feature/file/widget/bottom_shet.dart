import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/widget/popup_confirm_delete_folder.dart';
import 'package:vart_tools/feature/folder/widget/popup_folder.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetFile extends StatefulWidget {
  const BottomSheetFile({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<BottomSheetFile> createState() => _BottomSheetFileState();
}

class _BottomSheetFileState extends State<BottomSheetFile> {
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
                child: Text(
                  widget.file.name,
                  style: ResStyle.h6,
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            // showDialog(
            //   context: context,
            //   builder: (context) =>
            //       PopUpFolder(title: "sửa thư mục", folder: widget.file),
            // );
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
        InkWell(
          onTap: () {},
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Tags",
                  style: ResStyle.h6,
                ),
                Icon(Icons.push_pin),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // showDialog(
            //   context: context,
            //   builder: (context) =>
            //       PopupConfirmDeleteFolder(folder: widget.folder),
            // );
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
