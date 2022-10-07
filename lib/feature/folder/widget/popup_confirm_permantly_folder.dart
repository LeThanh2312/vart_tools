import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_trash_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../file/view_model/file_bloc.dart';

class PopupConfirmPermantlyFolder extends StatelessWidget {
  const PopupConfirmPermantlyFolder(
      {Key? key, required this.selectedIdObject, required this.onClear})
      : super(key: key);
  final List<SelectIdTrashModel> selectedIdObject;
  final VoidCallback onClear;

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
                "Mục này sẽ bị xoá.Không thể khôi phục hành động này?",
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
                      context.read<FolderTrashViewModel>().add(
                            PermanentlyDeleteEvent(
                                selectedIdsObject: selectedIdObject),
                          );
                      context.read<FilesViewModel>().add(
                            DeleteFileToFolderEvent(
                                selectedIdObject: selectedIdObject),
                          );
                      onClear();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Xóa",
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
