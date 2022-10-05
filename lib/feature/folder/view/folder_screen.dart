import 'package:flutter/material.dart';
import 'package:vart_tools/common/animation/scale_animation.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/camera/view_model/save_picture_bloc.dart';
import 'package:vart_tools/feature/file/view/file_screen.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/widget/folder_item.dart';
import 'package:vart_tools/feature/folder/widget/panel_control_folder.dart';
import 'package:vart_tools/feature/folder/widget/popup_new_folder.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:vart_tools/res/font_size.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({Key? key}) : super(key: key);

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  List<FileModel> files = [];
  late int newFolderId;
  @override
  void initState() {
    super.initState();
    context.read<FoldersViewModel>().add(LoadFoldersEvent());
  }

  // _showMyDialogNewFolder() async {
  //   var result = await showDialog(
  //   context: context,
  //   builder: (_) => const PopUpNewFolder(),);
  //         if (result != null) {
  //           setState(() {
  //             //Do stuff
  //           });
  //         }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavePictureViewModel, SavePictureState>(
      listener: (context, state) async {
        if (state.status == SavePictureStatus.success) {
          print('===== file: ${state.listFileSave.length}');
          files = state.listFileSave;
          var result = await showDialog(
            context: context,
            builder: (context) => const PopUpNewFolder(),
          );
          print("result dialog return ${result}");
          if(result) {
            newFolderId = context.read<FoldersViewModel>().state.newFolderId;
            print("folder id new: ${newFolderId}");
            print(files.length);
            context.read<FilesViewModel>().add(
                AddFilesEvent(files: files, folderId: newFolderId),
              );
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SearchWidget(),
                const SizedBox(height: 20),
                const PanelControlFolder(),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: BlocBuilder<FoldersViewModel, FoldersState>(
                    builder: (context, state) {
                      newFolderId = state.newFolderId;
                      print("new 1 ${newFolderId}");
                      if (state.isSuccess) {
                        if (state.filterFolder.isNotEmpty) {
                          return ReorderableListView(
                            onReorder: reorderData,
                            children: [
                              for (var folder in state.filterFolder)
                                Card(
                                  key: ValueKey(folder.name),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        ScaleRoute(
                                          page: FileScreen(
                                            folder: folder,
                                          ),
                                        ),
                                      );
                                    },
                                    child: FolderItem(folder: folder),
                                  ),
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
                                  ResAssets.icons.listFolderEmpty,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Chưa có thư mục ",
                                  style: ResStyle.blur_Text,
                                ),
                              ],
                            ),
                          );
                        }
                      } else if (state.isFailure) {
                        return Text(state.message);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  //   print("vo day roi may");
  //   // Navigator.push returns a Future that completes after calling
  //   // Navigator.pop on the Selection Screen.
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const PopUpNewFolder()),
  //   );

  //   // When a BuildContext is used from a StatefulWidget, the mounted property
  //   // must be checked after an asynchronous gap.
  //   if (!mounted) return;
  //   print(result);
  //   print(newFolderId);
  //   if(result == true && newFolderId != 0) {
  //     print("===luu file");
  //     context.read<FilesViewModel>().add(
  //               AddFilesEvent(files: files, folderId: newFolderId),
  //             );
  //   }
  // }

  void reorderData(int oldIndex, int newIndex) {
    final event = DragSortFolderEvent(oldIndex: oldIndex, newIndex: newIndex);
    context.read<FoldersViewModel>().add(event);
  }
}
