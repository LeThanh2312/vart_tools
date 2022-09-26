import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/widget/folder_item.dart';
import 'package:vart_tools/feature/folder/widget/panel_control_folder.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vart_tools/res/app_color.dart';

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
        padding: const EdgeInsets.only(left: 15, right: 10),
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
                    return ReorderableListView(
                      onReorder: reorderData,
                      children: [
                        for (var folder in state.filterFolder)
                          Card(
                            key: ValueKey(folder),
                            child: FolderItem(folder: folder),
                          ),
                      ],
                    );
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
