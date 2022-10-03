import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/file/widget/file_trash_item.dart';
import 'package:vart_tools/feature/folder/view/folder_screen.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_trash_bloc.dart';
import 'package:vart_tools/feature/folder/widget/folder_trash_item.dart';
import 'package:vart_tools/feature/folder/widget/popup_confirm_permantly_folder.dart';
import 'package:vart_tools/feature/folder/widget/popup_confirm_recover_folder.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderTrashScreen extends StatefulWidget {
  const FolderTrashScreen({Key? key, this.folders}) : super(key: key);
  final List<FolderModel>? folders;

  @override
  State<FolderTrashScreen> createState() => _FolderTrashScreenState();
}

class _FolderTrashScreenState extends State<FolderTrashScreen> {
  List idSelected = [];

  @override
  void initState() {
    super.initState();
    context.read<FolderTrashViewModel>().add(LoadFolderTrashEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FolderTrashViewModel, FolderTrashState>(
      listener: (context, state) {
        if (state.recoverStatus == FolderRecoverStatus.success) {
          context.read<FoldersViewModel>().add(LoadFoldersEvent());
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 70),
                  child: SearchWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      const Text(
                        "Thùng rác",
                        style: ResStyle.h6,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Text(
                              "Mục đã xóa",
                              style: ResStyle.h2,
                            ),
                            Positioned(
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text("Chọn Tất Cả")),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<FolderTrashViewModel, FolderTrashState>(
                    builder: (context, state) {
                      if (state.isSuccess) {
                        if (state.folders.isNotEmpty ||
                            state.files.isNotEmpty) {
                          return ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              for (var folder in state.folders)
                                FolderTrashItem(
                                  folder: folder,
                                  selectIdObject: SelectIdTrashModel(
                                      id: folder.id!, type: IdType.folder),
                                ),
                              for (var file in state.files)
                                FileTrashItem(
                                  file: file,
                                  slectIdObject: SelectIdTrashModel(
                                      id: file.id!, type: IdType.file),
                                ),
                            ],
                          );
                        } else {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Image.asset(
                                  ResAssets.icons.trashEmpty,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.fill,
                                ),
                                const Text(
                                  "Thùng rác trống",
                                  style: ResStyle.blur_Text,
                                ),
                              ],
                            ),
                          );
                        }
                      } else if (state.isFailure) {
                        return const Text("Something went wrong");
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.grayColor,
                      width: 1,
                    ),
                  ),
                ),
                child: BlocBuilder<FolderTrashViewModel, FolderTrashState>(
                    builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: Text("Xóa"),
                        onPressed: state.isEmptySelectedId
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      PopupConfirmPermantlyFolder(
                                          selectedIdObject:
                                              state.selectedIdObject),
                                );
                              },
                      ),
                      Text(
                        "đã chọn ${state.selectedIdObject.length} mục",
                        style: ResStyle.trash_text2,
                      ),
                      TextButton(
                        child: Text("Khôi phục"),
                        onPressed: state.isEmptySelectedId
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      PopupConfirmRecoverFolders(
                                          selectedIdObject:
                                              state.selectedIdObject),
                                );
                              },
                      ),
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
