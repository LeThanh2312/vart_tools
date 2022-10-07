import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopUpConfirmSaveFile extends StatefulWidget {
  const PopUpConfirmSaveFile({
    Key? key,
  }) : super(key: key);

  @override
  State<PopUpConfirmSaveFile> createState() => _PopUpConfirmSaveFileState();
}

class _PopUpConfirmSaveFileState extends State<PopUpConfirmSaveFile> {
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
                "Bạn muốn lưu file tại đây?",
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
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Hủy",
                    style: ResStyle.h2,
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grayColor),
                    onPressed: () {
                      // context
                      //     .read<FilesViewModel>()
                      //     .add(DeleteFileEvent(file: widget.file));
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "Đồng Ý",
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