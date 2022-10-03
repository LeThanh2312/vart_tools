import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/file/view_model/file_favourite_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_favourite_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum unFavouriteType { file, folder }

class PopUpComfirmUnFavourite extends StatefulWidget {
  const PopUpComfirmUnFavourite(
      {Key? key, this.file, this.folder, required this.type})
      : super(key: key);
  final FileModel? file;
  final FolderModel? folder;
  final unFavouriteType type;

  @override
  State<PopUpComfirmUnFavourite> createState() =>
      _PopUpComfirmUnFavouriteState();
}

class _PopUpComfirmUnFavouriteState extends State<PopUpComfirmUnFavourite> {
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
                "Bạn có muốn bỏ thích không?",
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
                      if (widget.type == unFavouriteType.file) {
                        context.read<FilesViewModel>().add(FavouriteFileEvent(
                            file: widget.file!, isFavourite: 0));
                        context
                            .read<FileFavouriteViewModel>()
                            .add(LoadDataFilesFavouriteEvent());
                      } else {
                        context.read<FoldersViewModel>().add(
                            FavouriteFolderEvent(
                                folder: widget.folder!, isFavourite: 0));
                        context
                            .read<FolderFavouriteViewModel>()
                            .add(LoadDataFavouriteEvent());
                      }
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
