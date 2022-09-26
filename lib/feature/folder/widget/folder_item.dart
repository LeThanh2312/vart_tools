import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/widget/bottom_sheet_folder.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:intl/intl.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({
    Key? key,
    required this.folder,
  }) : super(key: key);
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
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(folder.name!),
              const SizedBox(
                height: 5,
              ),
              Text(
                  "Ngày tạo: ${DateFormat('dd/m/yyyy hh:mm:ss').format(DateTime.parse(folder.dateCreate!))}")
            ],
          )),
          OutlinedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width,
                    child: BottomSheetFolder(folder: folder),
                  );
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
