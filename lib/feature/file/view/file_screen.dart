import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:vart_tools/res/assets.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({Key? key, required this.folder}) : super(key: key);
  final FolderModel folder;

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  late List<FileModel> filesData;
  late List<FileModel> files;
  @override
  void initState() {
    super.initState();
    filesData = [
      FileModel(
        name: "file 1",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img1,
        format: "JPG",
        dateCreate: DateTime.now().toString(),
        dateUpdate: DateTime.now().toString(),
      ),
      FileModel(
        name: "file 2",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img2,
        format: "JPG",
        dateCreate: DateTime.now().toString(),
        dateUpdate: DateTime.now().toString(),
      ),
      FileModel(
        name: "file 3",
        idFolder: widget.folder.id!,
        image: ResAssets.images.img3,
        format: "PNG",
        dateCreate: DateTime.now().toString(),
        dateUpdate: DateTime.now().toString(),
      ),
    ];
    files = context.read<FilesViewModel>().state.files;
    if (files.isEmpty) {
      createDbAndInsertData(filesData);
    }
  }

  void createDbAndInsertData(List<FileModel> files) async {
    try {
      print("insert data init");
      int i = 0;
      for (FileModel file in files) {
        await FileProvider().insertFile(file);
      }
      print("insert data success");
    } catch (e) {
      print(e);
    }
    context.read<FilesViewModel>().add(LoadFilesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchWidget(),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 15, bottom: 5),
              child: Text(
                "ngay tao",
                style: ResStyle.h2,
              ),
            ),
            Expanded(
              child: BlocBuilder<FilesViewModel, FilesViewState>(
                builder: (context, state) {
                  if (state.isSuccess) {
                    print("group by");
                    print(state.groupByDateUpdate);
                    return GridView.count(
                      primary: false,
                      // padding: const EdgeInsets.all(10),
                      // crossAxisSpacing: 10,
                      // mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                        for (var file in state.files)
                          Image.asset(
                            file.image!,
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3,
                          ),
                      ],
                    );
                    // print("xxx");
                    // print(state.files.length);
                    // return ListView(
                    //   children: [
                    //     for (var file in state.files)
                    //       Image.asset(
                    //         file.image!,
                    //         width: MediaQuery.of(context).size.width / 3,
                    //         height: MediaQuery.of(context).size.width / 3,
                    //       ),
                    //   ],
                    // );
                    // for (var file in state.files) {
                    //   Image.asset(
                    //     file.image!,
                    //     width: MediaQuery.of(context).size.width / 3,
                    //     height: MediaQuery.of(context).size.width / 3,
                    //   );
                    // }
                  } else if (state.isFailure) {
                    return Text(state.message);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
