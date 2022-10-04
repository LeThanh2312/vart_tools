import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_trash_bloc.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FileTrashItem extends StatefulWidget {
  const FileTrashItem(
      {Key? key, required this.slectIdObject, required this.file})
      : super(key: key);
  final SelectIdTrashModel slectIdObject;
  final FileModel file;

  @override
  State<FileTrashItem> createState() => _FileTrashItemState();
}

class _FileTrashItemState extends State<FileTrashItem> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckViewModel(),
        ),
      ],
      child: FileTrashItemBody(
          slectIdObject: widget.slectIdObject, file: widget.file),
    );
  }
}

class FileTrashItemBody extends StatefulWidget {
  const FileTrashItemBody(
      {Key? key, required this.slectIdObject, required this.file})
      : super(key: key);
  final SelectIdTrashModel slectIdObject;
  final FileModel file;

  @override
  State<FileTrashItemBody> createState() => _FileTrashItemBodyState();
}

class _FileTrashItemBodyState extends State<FileTrashItemBody> {
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
                        selectedIdsObject: widget.slectIdObject),
                  );
            },
            child: Row(
              children: [
                SizedBox(
                  child: Image.asset(widget.file.image!),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.file.name),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(DateFormat('dd/MM/yyyy hh:mm')
                        .format(DateTime.parse(widget.file.dateUpdate!)))
                  ],
                )),
                const SizedBox(
                  height: 30,
                  width: 30,
                ),
                state.isChecked(widget.slectIdObject)
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
