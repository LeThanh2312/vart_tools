import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopupNewFolder extends StatefulWidget {
  const PopupNewFolder({Key? key}) : super(key: key);

  @override
  State<PopupNewFolder> createState() => _PopupNewFolderState();
}

class _PopupNewFolderState extends State<PopupNewFolder> {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Column(
        children: [
          const Text("Tạo thư mục mới"),
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
                onPressed: () {
                  if (folderNameController.text.isEmpty) {
                    setState(() {
                      _validate = true;
                    });
                  } else {
                    if (!_isContain) {
                      context.read<FoldersViewModel>().add(
                            AddFolderEvent(
                              folder: FolderDb(
                                name: folderNameController.text,
                              ),
                            ),
                          );
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text('Đồng ý'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
