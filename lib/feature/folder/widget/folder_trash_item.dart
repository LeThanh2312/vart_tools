import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/res/assets.dart';

class FolderTrashItem extends StatelessWidget {
  const FolderTrashItem({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
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
          Expanded(child: Text(folder.name!)),
          const SizedBox(
            height: 30,
            width: 30,
          ),
          Icon(Icons.radio_button_unchecked),
        ],
      ),
    );
  }
}
