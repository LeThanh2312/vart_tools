import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_trash_bloc.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FolderTrashItem extends StatefulWidget {
  const FolderTrashItem(
      {Key? key, required this.folder, required this.selectIdObject})
      : super(key: key);
  final FolderModel folder;
  final SelectIdTrashModel selectIdObject;

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
      child: FolderTrashItemBody(
          folder: widget.folder, selectIdObject: widget.selectIdObject),
    );
  }
}

class FolderTrashItemBody extends StatefulWidget {
  const FolderTrashItemBody(
      {Key? key, required this.folder, required this.selectIdObject})
      : super(key: key);
  final FolderModel folder;
  final SelectIdTrashModel selectIdObject;

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
                    ToggleSelectFolderTrashEvent(
                        selectedIdsObject: widget.selectIdObject),
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
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.folder.name!),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat('dd/MM/yyyy hh:mm')
                        .format(DateTime.parse(widget.folder.dateUpdate!)))
                  ],
                )),
                const SizedBox(
                  height: 30,
                  width: 30,
                ),
                state.isChecked(widget.selectIdObject)
                    ? const Icon(
                        Icons.task_alt,
                        color: Color.fromARGB(255, 3, 112, 255),
                      )
                    : const Icon(Icons.radio_button_unchecked),
              ],
            ),
          ),
        );
      },
    );
  }
}
