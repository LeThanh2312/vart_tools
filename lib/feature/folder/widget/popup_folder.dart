import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopUpFolder extends StatefulWidget {
  const PopUpFolder({Key? key, required this.title, required this.folder})
      : super(key: key);
  final String title;
  final FolderModel? folder;

  @override
  State<PopUpFolder> createState() => _PopUpFolderState();
}

class _PopUpFolderState extends State<PopUpFolder> {
  TextEditingController folderNameController = TextEditingController();
  bool _validate = false;
  bool _isContain = false;
  bool _disable = true;

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
                hintText: widget.title == 'sửa thư mục'
                    ? '${widget.folder!.name}'
                    : 'Thư mục mới',
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

              if (!_validate && !_isContain) {
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
                    ? () async {
                        if (folderNameController.text.isEmpty) {
                          setState(() {
                            _validate = true;
                          });
                        } else {
                          if (!_isContain) {
                            print("vo day");
                            if (widget.folder == null) {
                              print("add");
                              context.read<FoldersViewModel>().add(
                                    AddFolderEvent(
                                      folder: FolderModel(
                                          name: folderNameController.text,
                                          dateCreate: DateTime.now().toString(),
                                          dateUpdate:
                                              DateTime.now().toString()),
                                    ),
                                  );
                            } else {
                              print("update");
                              List<FolderModel> folders = await FolderProvider()
                                  .getFolders(widget.folder!.id);
                              FolderModel data = folders.first;
                              data.name = folderNameController.text;
                              data.dateUpdate = DateTime.now().toString();
                              context.read<FoldersViewModel>().add(
                                    RenameFolderEvent(
                                      folder: data,
                                    ),
                                  );
                            }
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        }
                      }
                    : null,
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: AppColors.grayColor,
                // ),
                child: const Text('Đồng ý'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
