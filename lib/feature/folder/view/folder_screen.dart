import 'package:flutter/material.dart';
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
    context.read<FoldersViewModel>().add(FoldersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchWidget(),
            const SizedBox(height: 40),
            const PanelControlFolder(),
            Expanded(
              child: BlocBuilder<FoldersViewModel, FoldersState>(
                builder: (context, state) {
                  if (state is SuccessInitFolders) {
                    return ListView(
                      children: [
                        for (var folder in state.folders)
                          FolderItem(folderName: folder.name),
                      ],
                    );
                  } else if (state is ErrorInitFolders) {
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
}
