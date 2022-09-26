import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_trash_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopupConfirmRecoverFolders extends StatelessWidget {
  const PopupConfirmRecoverFolders({Key? key, required this.selectedFolderIds})
      : super(key: key);
  final List<int> selectedFolderIds;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(15),
      content: Container(
        height: 200,
        width: double.infinity,
        color: AppColors.colorBackgroundPopup,
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 50),
              child: Text(
                "Bạn có muốn khôi phục mục đã xoá không?",
                style: ResStyle.h2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grayColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Hủy",
                      style: ResStyle.h2,
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grayColor),
                    onPressed: () {
                      print(selectedFolderIds);
                      context.read<FolderTrashViewModel>().add(
                          RecoverFolderEvent(selectedIds: selectedFolderIds));
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Khôi phục",
                      style: ResStyle.h2,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}