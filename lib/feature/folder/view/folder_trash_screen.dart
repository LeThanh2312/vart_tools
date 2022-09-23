import 'package:flutter/material.dart';
import 'package:vart_tools/database/folder_database.dart';
import 'package:vart_tools/feature/folder/view/folder_screen.dart';
import 'package:vart_tools/feature/folder/view_model/folders_trash_bloc.dart';
import 'package:vart_tools/feature/folder/widget/folder_trash_item.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderTrashScreen extends StatefulWidget {
  const FolderTrashScreen({Key? key, this.folders}) : super(key: key);
  final List<FolderModel>? folders;

  @override
  State<FolderTrashScreen> createState() => _FolderTrashScreenState();
}

class _FolderTrashScreenState extends State<FolderTrashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<FolderTrashViewModel>().add(LoadDataTrashEvent());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(alignment: Alignment.center, child: SearchWidget()),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      const Text(
                        "Thùng rác",
                        style: ResStyle.h6,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Mục đã xóa",
                        style: ResStyle.h2,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<FolderTrashViewModel, FolderTrashState>(
                    builder: (context, state) {
                      if (state is LoadingDataTrashSuccessState) {
                        return ListView(
                          children: [
                            for (var folder in state.folders)
                              FolderTrashItem(
                                folder: folder,
                              ),
                          ],
                        );
                      } else if (state is LoadingDataTrashErrorState) {
                        return Text(state.message);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                )
                // const Padding(
                //   padding: EdgeInsets.only(left: 40, right: 40),
                //   child:

                //   FolderTrashItem(folder: null),
                // ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.grayColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text(
                      "Xóa",
                      style: ResStyle.trash_text1,
                    ),
                    Text(
                      "đã chọn (1) mục",
                      style: ResStyle.trash_text2,
                    ),
                    Text("khôi phục", style: ResStyle.trash_text1)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
