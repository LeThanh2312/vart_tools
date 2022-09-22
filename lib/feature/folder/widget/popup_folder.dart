import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopUpFolder extends StatefulWidget {
  const PopUpFolder({Key? key, required this.title, required this.folderId})
      : super(key: key);
  final String title;
  final int? folderId;

  @override
  State<PopUpFolder> createState() => _PopUpFolderState();
}

class _PopUpFolderState extends State<PopUpFolder> {
  TextEditingController folderNameController = TextEditingController();
  bool _validate = false;
  bool _isContain = false;

  bool _checkFolderExist(String folderName) {
    var folders = context.read<FoldersViewModel>().state.folders;
    bool status = false;
    for (var folder in folders) {
      if (folder.name == folderNameController.text) {
        status = true;
        return status;
      } else {
        status = false;
      }
    }
    return status;
  }

  // Future<List<FolderModel>> getDetailFolder(int id) async {
  //   return await FolderProvider().getFolders(id);
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Column(
        children: [
          Text(widget.title),
          Divider(
            height: 15,
            thickness: 1,
            color: AppColors.grayColor,
          ),
        ],
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: folderNameController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Thư mục mới',
                isDense: true,
                contentPadding: const EdgeInsets.all(15),
                errorText: _validate
                    ? 'vui lòng nhập tên folder'
                    : _isContain
                        ? "tên folder đã tồn tại"
                        : null),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _validate = true;
                });
              } else {
                if (_checkFolderExist(folderNameController.text)) {
                  setState(() {
                    _isContain = true;
                  });
                } else {
                  setState(() {
                    _isContain = false;
                  });
                }
                setState(() {
                  _validate = false;
                });
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grayColor,
                ),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (folderNameController.text.isEmpty) {
                    setState(() {
                      _validate = true;
                    });
                  } else {
                    if (!_isContain) {
                      if (widget.folderId == null) {
                        context.read<FoldersViewModel>().add(
                              AddFolderEvent(
                                folder: FolderModel(
                                    name: folderNameController.text,
                                    dateCreate: DateTime.now().toString(),
                                    dateUpdate: DateTime.now().toString()),
                              ),
                            );
                      } else {
                        List<FolderModel> folders =
                            await FolderProvider().getFolders(widget.folderId);
                        FolderModel data = folders.first;
                        data.name = folderNameController.text;
                        data.dateUpdate = DateTime.now().toString();
                        context.read<FoldersViewModel>().add(
                              RenameFolderEvent(
                                folder: data,
                              ),
                            );
                      }
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grayColor,
                ),
                child: const Text('Đồng ý'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
