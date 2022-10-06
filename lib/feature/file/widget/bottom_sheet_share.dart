import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetShare extends StatefulWidget {
  const BottomSheetShare({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<BottomSheetShare> createState() => _BottomSheetShareState();
}

class _BottomSheetShareState extends State<BottomSheetShare> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image.asset(
                    ResAssets.icons.iconFacebook,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Facebook"),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    ResAssets.icons.iconSky,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Skype"),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    ResAssets.icons.iconTweet,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Twitter"),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    ResAssets.icons.iconZalo,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Zalo"),
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    ResAssets.icons.iconGmail,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Gmail"),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 15),
          child: Row(
            children: [
              const Expanded(
                  child: Text(
                "Xuất file PDF",
                style: ResStyle.h2,
              )),
              Image.asset(
                ResAssets.icons.iconExportPdf,
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        Divider(
          height: 15,
          thickness: 1,
          color: AppColors.grayColor,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 5),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("In flies", style: ResStyle.h2)),
        ),
      ],
    );
  }
}
