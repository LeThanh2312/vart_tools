import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vart_tools/res/assets.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({Key? key, required this.folderName}) : super(key: key);
  final String folderName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(ResAssets.icons.folder),
          ),
          const SizedBox(width: 30),
          Expanded(child: Text(folderName)),
          const SizedBox(width: 30),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.more_horiz),
          )
        ],
      ),
    );
  }
}
