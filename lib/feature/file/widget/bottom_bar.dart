import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/file/widget/popup_confirm_delete_file.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBarFileDetail extends StatefulWidget {
  const BottomBarFileDetail({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<BottomBarFileDetail> createState() => _BottomBarFileDetailState();
}

class _BottomBarFileDetailState extends State<BottomBarFileDetail> {
  late bool isFavourite = widget.file.isFavourite == 0 ? false : true;

  void _favouriteFile() {
    context.read<FilesViewModel>().add(FavouriteFileEvent(
        file: widget.file, isFavourite: isFavourite ? 1 : 0));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: AppColors.bottomSheetFileDetailColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            ResAssets.icons.iconDowload,
            height: 30,
            width: 30,
            fit: BoxFit.fill,
          ),
          Image.asset(
            ResAssets.icons.iconShare,
            height: 30,
            width: 30,
            fit: BoxFit.fill,
          ),
          InkWell(
            onTap: () {
              _favouriteFile();
              setState(() {
                isFavourite = !isFavourite;
              });
            },
            child: isFavourite
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(Icons.favorite_border),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => PopUpConfirmDeleteFile(file: widget.file),
              );
            },
            child: Image.asset(
              ResAssets.icons.iconDelete,
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
