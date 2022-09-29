import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/res/assets.dart';

class FileFavouriteItem extends StatefulWidget {
  const FileFavouriteItem({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<FileFavouriteItem> createState() => _FileFavouriteItemState();
}

class _FileFavouriteItemState extends State<FileFavouriteItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(widget.file.image!),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(child: Text(widget.file.name)),
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
