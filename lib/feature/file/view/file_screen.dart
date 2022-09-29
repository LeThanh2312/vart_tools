import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/file/view/file_detail_screen.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/file/widget/popup_confirm_delete_file.dart';
import 'package:vart_tools/feature/file/widget/popup_confirm_delete_mulplite_file.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  late List<FileModel> filesData;
  late List<FileModel> files;
  bool isSelectionMode = false;
  List<int?> _idSelected = [];
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    filesData = [
      FileModel(
        name: "file 1",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img1,
        format: "JPG",
        size: 250,
        dateCreate: '2022-09-29 08:28:58',
        dateUpdate: '2022-09-29 08:28:58',
      ),
      FileModel(
        name: "file 2",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img2,
        format: "JPG",
        size: 550,
        dateCreate: '2022-09-29 08:29:58',
        dateUpdate: '2022-09-29 08:29:58',
      ),
      FileModel(
        name: "file 3",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img3,
        format: "PNG",
        size: 200,
        dateCreate: '2022-09-28 08:28:58',
        dateUpdate: '2022-09-28 08:28:58',
      ),
      FileModel(
        name: "file 4",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img3,
        format: "PNG",
        size: 200,
        dateCreate: '2022-09-25 08:31:58',
        dateUpdate: '2022-09-25 08:31:58',
      ),
      FileModel(
        name: "file 5",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img3,
        format: "PNG",
        size: 200,
        dateCreate: '2022-09-25 08:30:58',
        dateUpdate: '2022-09-25 08:30:58',
      ),
      FileModel(
        name: "file 6",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img3,
        format: "PNG",
        size: 200,
        dateCreate: '2022-09-24 08:28:58',
        dateUpdate: '2022-09-24 08:28:58',
      ),
    ];
    files = context.read<FilesViewModel>().state.files;
    print('file data init : ${files}');
    if (files.isEmpty) {
      context.read<FilesViewModel>().add(AddFilesEvent(files: filesData));
    }
    context.read<FilesViewModel>().add(LoadFilesEvent());
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
    return SafeArea(
        child: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isSelectionMode
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color.fromARGB(255, 6, 122, 255),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isSelectionMode = false;
                            _idSelected.clear();
                          });
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Selection (${_idSelected.length})',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: _idSelected.isEmpty
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      PopUpConfirmDeleteMulpliteFile(
                                    idFiles: _idSelected,
                                    onClear: () {
                                      _idSelected.clear();
                                    },
                                  ),
                                );
                              },
                      ),
                      SizedBox(
                        width: 100,
                        child: TextButton(
                          child: !_selectAll
                              ? const Text(
                                  'Select All',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                )
                              : const Text(
                                  'Unselect All',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
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
                      ),
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(20),
                  child: SearchWidget(),
                ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      context
                          .read<RedirectFileScreenViewModel>()
                          .add(RedirectFileScreenEvent(redirect: false));
                    },
                    child: const Icon(Icons.arrow_back_ios)),
                Text(
                  widget.folder.name!,
                  style: ResStyle.h6,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<FilesViewModel, FilesViewState>(
              builder: (context, state) {
                if (state.isSuccess) {
                  if(state.files.isNotEmpty){
                    files = state.files;
                  return ListView(
                      children: state.groupByDateUpdate.keys.map((key) {
                    final value = state.groupByDateUpdate[key];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
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
                                        int id =
                                            int.parse(file["id"].toString());
                                        if (checkIdExistIdSelected(id)) {
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
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FileDetailScrenn(
                                              file: FileModel.fromMap(file),
                                            ),
                                          ),
                                        ),
                                onLongPress: () {
                                  setState(() {
                                    isSelectionMode = true;
                                    _idSelected
                                        .add(int.parse(file["id"].toString()));
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      '${file["image"]}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: SizedBox(
                                        child: isSelectionMode
                                            ? checkIdExistIdSelected(int.parse(
                                                    file["id"].toString()))
                                                ? const Icon(
                                                    Icons.check_box,
                                                    color: Color.fromARGB(
                                                        255, 0, 170, 255),
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
                  }else {
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
    ));
  }
}
