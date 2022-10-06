import 'package:flutter/material.dart';
import 'package:vart_tools/common/toast/custom_toast.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PopUpRenameFolder extends StatefulWidget {
  const PopUpRenameFolder({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  State<PopUpRenameFolder> createState() => _PopUpRenameFolderState();
}

class _PopUpRenameFolderState extends State<PopUpRenameFolder> {
  TextEditingController folderNameController = TextEditingController();
  bool _validate = false;
  bool _isContain = false;
  bool _disable = true;
  late FToast fToast;

  bool _checkFolderExist(String folderName) {
    var folders = context.read<FoldersViewModel>().state.folders;
    bool status = false;
    for (var folder in folders) {
      if (folder.name == folderName) {
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
    folderNameController.text = widget.folder.name!;
  }

  void _showToastRenameSuccess(String message) {
    if (message == '') {
      fToast.showToast(
          child: const ToastSuccess(message: "Rename folder thành công."));
    } else {
      fToast.showToast(
          child: const ToastSuccess(message: "Rename folder thất bại."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Column(
          children: [
            const Text('Sửa mục mới'),
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
                if (value != widget.folder.name && _checkFolderExist(value)) {
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
                            // if (widget.folder == null) {
                            // context.read<FoldersViewModel>().add(
                            //       AddFolderEvent(
                            //         folder: FolderModel(
                            //             name: folderNameController.text,
                            //             dateCreate: DateTime.now().toString(),
                            //             dateUpdate: DateTime.now().toString()),
                            //       ),
                            //     );
                            // _showToastAddSuccess(
                            //     context.read<FoldersViewModel>().state.message);
                            // } else {
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
                            // }
                            _showToastRenameSuccess(
                                context.read<FoldersViewModel>().state.message);
                            FocusScope.of(context).unfocus();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
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
