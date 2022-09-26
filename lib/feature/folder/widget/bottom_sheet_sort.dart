import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSheetSort extends StatefulWidget {
  const BottomSheetSort({Key? key}) : super(key: key);

  @override
  State<BottomSheetSort> createState() => _BottomSheetSortState();
}

class _BottomSheetSortState extends State<BottomSheetSort> {
  List<FolderModel> folders = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoldersViewModel, FoldersState>(
        builder: (context, state) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: AppColors.grayColor,
                  padding: const EdgeInsets.only(
                    top: 5,
                    left: 20,
                    bottom: 5,
                  ),
                  child: const Text(
                    "Sắp xếp",
                    style: ResStyle.h6,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              context
                  .read<FoldersViewModel>()
                  .add(SortFolderEvent(type: SortType.byCreatedDateACS));
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ngày tạo (Cũ nhất)",
                    style: ResStyle.h6,
                  ),
                  state.sortType == SortType.byCreatedDateACS
                      ? const Icon(Icons.done,
                          color: Color.fromARGB(255, 8, 161, 238))
                      : const SizedBox()
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context
                  .read<FoldersViewModel>()
                  .add(SortFolderEvent(type: SortType.byCreatedDateDESC));
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    " Ngày tạo (Mới nhất)",
                    style: ResStyle.h6,
                  ),
                  state.sortType == SortType.byCreatedDateDESC
                      ? const Icon(Icons.done,
                          color: Color.fromARGB(255, 8, 161, 238))
                      : const SizedBox()
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context
                  .read<FoldersViewModel>()
                  .add(SortFolderEvent(type: SortType.byAZ));
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tên tài liệu ( A đến Z)",
                    style: ResStyle.h6,
                  ),
                  state.sortType == SortType.byAZ
                      ? const Icon(Icons.done,
                          color: Color.fromARGB(255, 8, 161, 238))
                      : const SizedBox()
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context
                  .read<FoldersViewModel>()
                  .add(SortFolderEvent(type: SortType.byZA));
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tên tài liệu ( Z đến A)",
                    style: ResStyle.h6,
                  ),
                  state.sortType == SortType.byZA
                      ? const Icon(Icons.done,
                          color: Color.fromARGB(255, 8, 161, 238))
                      : const SizedBox()
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
