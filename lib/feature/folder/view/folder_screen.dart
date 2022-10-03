import 'package:flutter/material.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/widget/folder_item.dart';
import 'package:vart_tools/feature/folder/widget/panel_control_folder.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<FoldersViewModel>().add(LoadFoldersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SearchWidget(),
            const SizedBox(height: 40),
            const PanelControlFolder(),
            Expanded(
              child: BlocBuilder<FoldersViewModel, FoldersState>(
                builder: (context, state) {
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
                                  context
                                      .read<RedirectFileScreenViewModel>()
                                      .add(RedirectFileScreenEvent(
                                          redirect: true, folder: folder));
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
    );
  }

  void reorderData(int oldIndex, int newIndex) {
    final event = DragSortFolderEvent(oldIndex: oldIndex, newIndex: newIndex);
    context.read<FoldersViewModel>().add(event);
  }
}
