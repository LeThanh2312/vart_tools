import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_trash_bloc.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderTrashItem extends StatefulWidget {
  const FolderTrashItem({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  State<FolderTrashItem> createState() => _FolderTrashItemState();
}

class _FolderTrashItemState extends State<FolderTrashItem> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckViewModel(),
        ),
      ],
      child: FolderTrashItemBody(folder: widget.folder),
    );
  }
}

class FolderTrashItemBody extends StatefulWidget {
  const FolderTrashItemBody({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  State<FolderTrashItemBody> createState() => _FolderTrashItemBodyState();
}

class _FolderTrashItemBodyState extends State<FolderTrashItemBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderTrashViewModel, FolderTrashState>(
      builder: (context, state) {
        return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          child: InkWell(
            onTap: () {
              context.read<FolderTrashViewModel>().add(
                    ToggleSelectFolderTrashEvent(folder: widget.folder),
                  );
            },
            child: Row(
              children: [
                SizedBox(
                  child: Image.asset(ResAssets.icons.folder),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(child: Text(widget.folder.name!)),
                const SizedBox(
                  height: 30,
                  width: 30,
                ),
                state.isChecked(widget.folder)
                    ? const Icon(Icons.task_alt)
                    : const Icon(Icons.radio_button_unchecked),
              ],
            ),
          ),
        );
      },
    );
  }
}
