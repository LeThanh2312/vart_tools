import 'package:flutter/material.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopUpConfirmDeleteMulpliteFile extends StatefulWidget {
  // final VoidCallback onClear;
  const PopUpConfirmDeleteMulpliteFile(
      {Key? key,
      required this.idFiles,
      // required this.onClear,
      required this.folderId})
      : super(key: key);
  final List<int?> idFiles;
  final int folderId;

  @override
  State<PopUpConfirmDeleteMulpliteFile> createState() =>
      _PopUpConfirmDeleteMulpliteFileState();
}

class _PopUpConfirmDeleteMulpliteFileState
    extends State<PopUpConfirmDeleteMulpliteFile> {
  // Future<bool> deleteDate(int id) async {
  //   await context.read<FilesViewModel>().add(DeleteMulpliteEvent(fileId: widget.idFiles, folderId: widget.folderId));
  //   if(data.isEmpty){
  //     return true;
  //   }else {
  //     return false;
  //   }
  // }
  Future<bool> _deleteData() async {
    context.read<FilesViewModel>().add(
        DeleteMulpliteEvent(fileId: widget.idFiles, folderId: widget.folderId));
    return Future.value(true);
  }

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
                "Bạn có muốn các file đã chọn không?",
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
                      context.read<FilesViewModel>().add(DeleteMulpliteEvent(
                          fileId: widget.idFiles, folderId: widget.folderId));
                      Navigator.of(context).pop();
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
