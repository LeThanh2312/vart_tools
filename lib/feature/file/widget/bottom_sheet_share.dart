import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/widget/popup_confirm_delete_folder.dart';
import 'package:vart_tools/feature/folder/widget/popup_folder.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetShare extends StatefulWidget {
  const BottomSheetShare({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  State<BottomSheetShare> createState() => _BottomSheetShareState();
}

class _BottomSheetShareState extends State<BottomSheetShare> {
  // late bool isFavourite = widget.folder.favourite == 0 ? false : true;

  // void _favouriteFolder() {
  //   context.read<FoldersViewModel>().add(FavouriteFolderEvent(
  //       folder: widget.folder, isFavourite: isFavourite ? 0 : 1));
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
                // Icon
                )
          ],
        )
      ],
    );
  }
}
