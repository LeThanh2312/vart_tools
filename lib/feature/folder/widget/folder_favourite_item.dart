import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/res/assets.dart';

class FolderFavouriteItem extends StatefulWidget {
  const FolderFavouriteItem({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  State<FolderFavouriteItem> createState() => _FolderFavouriteItemState();
}

class _FolderFavouriteItemState extends State<FolderFavouriteItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(ResAssets.icons.folder),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(child: Text(widget.folder.name!)),
          const SizedBox(
            height: 30,
            width: 30,
          ),
          const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}