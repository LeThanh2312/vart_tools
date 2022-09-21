import 'package:flutter/material.dart';
import 'package:vart_tools/feature/folder/widget/bottom_sheet_Icon_more.dart';
import 'package:vart_tools/res/assets.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({Key? key, this.folderName}) : super(key: key);
  final String? folderName;

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
          Expanded(child: Text(folderName!)),
          const SizedBox(
            height: 30,
            width: 30,
          ),
          OutlinedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: const BottomSheetIconMore());
                },
              );
            },
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
