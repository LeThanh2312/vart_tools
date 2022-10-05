import 'package:flutter/material.dart';
import 'package:vart_tools/common/toast/custom_toast.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PopUpNewFolder extends StatefulWidget {
  const PopUpNewFolder({Key? key}) : super(key: key);
  // final List<FileModel> files;

  @override
  State<PopUpNewFolder> createState() => _PopUpNewFolderState();
}

class _PopUpNewFolderState extends State<PopUpNewFolder> {
  TextEditingController folderNameController = TextEditingController();
  bool _validate = false;
  bool _isContain = false;
  bool _disable = true;
  late FToast fToast;
  int newFolderId = 0;

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
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void _showToastAddSuccess(String message) {
    if (message == '') {
      fToast.showToast(
          child: const ToastSuccess(message: "Tạo folder thành công."));
    } else {
      fToast.showToast(
          child: const ToastSuccess(message: "Tạo folder thất bại."));
    }
  }

  // void _saveFiles(int folderId, List<FileModel> files) {
  //   context.read<FilesViewModel>().add(
  //         AddFilesEvent(files: files, folderId: folderId),
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Column(
          children: [
            const Text('Taọ Thư mục mới'),
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
            controller: folderNameController,
            autofocus: true,
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
                  Navigator.pop(context, false);
                  FocusScope.of(context).unfocus();
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
                            context.read<FoldersViewModel>().add(
                                  AddFolderEvent(
                                    folder: FolderModel(
                                      name: folderNameController.text,
                                      dateCreate: DateTime.now().toString(),
                                      dateUpdate: DateTime.now().toString(),
                                    ),
                                  ),
                                );
                                // print("===new folder id ${newFolderId}");
                                // if(newFolderId != 0){
                                //   print(newFolderId);
                                //   _saveFiles(newFolderId, widget.files);
                                // }
                            _showToastAddSuccess(
                                context.read<FoldersViewModel>().state.message);
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context, true);
                          }
                        }
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
