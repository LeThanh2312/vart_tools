import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vart_tools/common/animation/scale_animation.dart';
import 'package:vart_tools/common/toast/custom_toast.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/file/view/file_detail_screen.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/file/widget/popup_add_tag.dart';
import 'package:vart_tools/feature/file/widget/popup_confirm_delete_mulplite_file.dart';
import 'package:vart_tools/feature/file/widget/popup_confirm_save_file.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class FileScreen extends StatefulWidget {
  FileScreen(
      {Key? key,
      required this.folder,
      this.filesSave,
      this.isSelectFolder,
      this.updateIsSelectFolder})
      : super(key: key);
  final FolderModel folder;
  final List<FileModel>? filesSave;
  bool? isSelectFolder;
  final void Function(bool value)? updateIsSelectFolder;

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> with SingleTickerProviderStateMixin {
  late List<FileModel> filesData;
  late List<FileModel> files;
  bool isSelectionMode = false;
  List<int?> _idSelected = [];
  bool _selectAll = false;
  bool progress = true;
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late FToast fToast;


  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });
    controller.forward();

    fToast = FToast();
    fToast.init(context);

    context
        .read<FilesViewModel>()
        .add(LoadFilesEvent(folderId: widget.folder.id!));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPopup(context);
    });
  }

  void showPopup(BuildContext context) async {
    if (widget.filesSave!.isNotEmpty && widget.isSelectFolder!) {
      var result = await showDialog(
        context: context,
        builder: (context) => ScaleTransition(scale: scaleAnimation, child: const PopUpConfirmSaveFile(),),
      );
      if (result) {
        try{
        widget.updateIsSelectFolder!(false);
        ProgressDialog pd = ProgressDialog(context: context);
          pd.show(max: 100,msg: 'Đang lưu file...',
          progressType: ProgressType.valuable,);
          for (int i = 0; i <= 100; i++) {
            pd.update(value: i);
            i++;
            await Future.delayed(Duration(milliseconds: 50));
          }
        context.read<FilesViewModel>().add(AddFilesEvent(
            files: widget.filesSave!, folderId: widget.folder.id!));
        fToast.showToast(
          child: const ToastSuccess(message: "Lưu file thành công."));
        }catch (e){
          fToast.showToast(
          child: const ToastFaild(message: 'error'));
        }
        
      }
    }
  }

  Future<bool> checkDataExist(int id) async {
    List<FileModel> data = await FileProvider().getFiles(id);
    if (data.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIdExistIdSelected(int id) {
    if (_idSelected.contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _idSelected.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FilesViewModel, FilesViewState>(
      listener: (context, state) {
        if (state.isDeleteSucees) {
          setState(() {
            _idSelected.clear();
          });

          context
              .read<FilesViewModel>()
              .add(LoadFilesEvent(folderId: widget.folder.id!));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: isSelectionMode
              ? Text('Đã Chọn (${_idSelected.length})')
              : Text(widget.folder.name!),
          leading: isSelectionMode
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        isSelectionMode = false;
                        _idSelected.clear();
                      },
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
          actions: isSelectionMode
              ? [
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => PopUpAddTag(
                                files: files,
                                folderId: widget.folder.id!,
                              ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.sell,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PopUpConfirmDeleteMulpliteFile(
                          idFiles: _idSelected,
                          folderId: widget.folder.id!,
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: !_selectAll
                        ? const Text(
                            'Chọn Tất Cả',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )
                        : const Text(
                            'Bỏ Chọn',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                    onPressed: () {
                      _selectAll = !_selectAll;
                      setState(() {
                        if (_selectAll) {
                          _idSelected = files.map((e) => e.id).toList();
                        } else {
                          _idSelected.clear();
                        }
                      });
                    },
                  ),
                ]
              : [],
        ),
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Expanded(
                  child: BlocBuilder<FilesViewModel, FilesViewState>(
                    builder: (context, state) {
                      if (state.isSuccess) {
                        if (state.files.isNotEmpty) {
                          files = state.files;
                          return ListView(
                              children: state.groupByDateUpdate.keys.map((key) {
                            final value = state.groupByDateUpdate[key];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20, left: 20),
                                  child: Text(key.toString()),
                                ),
                                GridView.count(
                                  primary: false,
                                  padding: EdgeInsets.all(20),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    for (var file in value!)
                                      InkWell(
                                        onTap: isSelectionMode
                                            ? () {
                                                int id = int.parse(
                                                    file["id"].toString());
                                                if (checkIdExistIdSelected(
                                                    id)) {
                                                  setState(() {
                                                    _idSelected.remove(id);
                                                  });
                                                } else {
                                                  setState(() {
                                                    _idSelected.add(int.parse(
                                                        file["id"].toString()));
                                                  });
                                                }
                                              }
                                            : () => Navigator.push(
                                                  context,
                                                  SlideRightRoute(
                                                    page: FileDetailScreen(
                                                      file: FileModel.fromMap(
                                                          file),
                                                    ),
                                                  ),
                                                ),
                                        onLongPress: () {
                                          setState(() {
                                            isSelectionMode = true;
                                            _idSelected.add(int.parse(
                                                file["id"].toString()));
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            Image.file(
                                                File('${file["image"]}'), 
                                                fit: BoxFit.cover, 
                                                width: double.infinity, 
                                                height: double.infinity,),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: SizedBox(
                                                child: isSelectionMode
                                                    ? checkIdExistIdSelected(
                                                            int.parse(file["id"]
                                                                .toString()))
                                                        ? const Icon(
                                                            Icons.check_box,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    170,
                                                                    255),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .check_box_outline_blank,
                                                            color: Colors.black,
                                                          )
                                                    : null,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            );
                          }).toList());
                        } else {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Image.asset(
                                  ResAssets.icons.listFileEmpty,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "Chưa có file trong mục này",
                                  style: ResStyle.blur_Text,
                                ),
                              ],
                            ),
                          );
                        }
                      } else if (state.isFailure) {
                        return Text(state.message);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
