import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/widget/popup_confirm_delete_folder.dart';
import 'package:vart_tools/feature/folder/widget/popup_folder.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetFolder extends StatefulWidget {
  const BottomSheetFolder({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  State<BottomSheetFolder> createState() => _BottomSheetFolderState();
}

class _BottomSheetFolderState extends State<BottomSheetFolder> {
  late bool isFavourite = widget.folder.favourite == 0 ? false : true;

  void _favouriteFolder() {
    context.read<FoldersViewModel>().add(FavouriteFolderEvent(
        folder: widget.folder, isFavourite: isFavourite ? 0 : 1));
  }

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
                  widget.folder.name!,
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
                  PopUpFolder(title: "sửa thư mục", folderId: widget.folder.id),
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
        InkWell(
          onTap: () {
            _favouriteFolder();
            setState(() {
              isFavourite = !isFavourite;
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Yêu thích",
                  style: ResStyle.h6,
                ),
                !isFavourite
                    ? const Icon(Icons.favorite_border)
                    : const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  PopupConfirmDeleteFolder(folder: widget.folder),
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
