import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopUpAddTag extends StatefulWidget {
  const PopUpAddTag({Key? key, required this.files, required this.folderId})
      : super(key: key);
  final List<FileModel> files;
  final int folderId;

  @override
  State<PopUpAddTag> createState() => _PopUpAddTagState();
}

class _PopUpAddTagState extends State<PopUpAddTag> {
  TextEditingController tagNameController = TextEditingController();
  bool _validate = false;
  bool _disable = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Column(
          children: [
            const Text("Thêm Tags"),
            Divider(
              height: 15,
              thickness: 1,
              color: AppColors.grayColor,
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: tagNameController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Nhập Tags',
                isDense: true,
                contentPadding: const EdgeInsets.all(15),
                errorText: _validate ? 'vui lòng nhập tags' : null),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _validate = true;
                });
              } else {
                setState(() {
                  _validate = false;
                });
              }

              if (!_validate) {
                _disable = false;
              } else {
                _disable = true;
              }
            },
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: (!_disable)
                    ? () {
                        context.read<FilesViewModel>().add(AddTagsEvent(
                            files: widget.files,
                            tagName: tagNameController.text,
                            folderId: widget.folderId));
                        Navigator.of(context).pop();
                      }
                    : null,
                child: const Text('Đồng ý'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
