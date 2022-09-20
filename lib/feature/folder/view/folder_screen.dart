import 'package:flutter/material.dart';
import 'package:vart_tools/feature/folder/widget/folder_item.dart';
import 'package:vart_tools/feature/folder/widget/popup_new_folder.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/app_constants.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({Key? key}) : super(key: key);

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final List<String> folderNames = [
    "Thuy Dung",
    "Thuy Tien",
    "LyLy",
    "Dowload"
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          margin: const EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            bottom: defaultPadding,
            top: defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchWidget(),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Tất cả 2",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  MaterialButton(
                    height: 42,
                    minWidth: 42,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => PopupNewFolder(),
                      );
                    },
                    color: AppColors.grayColor,
                    shape: const CircleBorder(),
                    child: Image.asset(
                      ResAssets.icons.new_folder,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  MaterialButton(
                    height: 42,
                    minWidth: 42,
                    onPressed: () {},
                    color: AppColors.grayColor,
                    shape: const CircleBorder(),
                    child: Image.asset(
                      ResAssets.icons.sort_folder,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  MaterialButton(
                    height: 42,
                    minWidth: 42,
                    onPressed: () {},
                    color: AppColors.grayColor,
                    shape: const CircleBorder(),
                    child: Image.asset(
                      ResAssets.icons.delete,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),
              for (var item in folderNames) FolderItem(folderName: item)
            ],
          ),
        ),
      ),
    );
  }
}
