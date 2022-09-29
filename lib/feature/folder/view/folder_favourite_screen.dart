import 'package:flutter/material.dart';
import 'package:vart_tools/database/file_database.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/file/view_model/file_favourite_bloc.dart';
import 'package:vart_tools/feature/file/widget/file_favourite_item.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_favourite_bloc.dart';
import 'package:vart_tools/feature/folder/widget/folder_favourite_item.dart';
import 'package:vart_tools/feature/home/widgets/search_widget.dart';
import 'package:vart_tools/res/font_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderFavouriteScreen extends StatefulWidget {
  const FolderFavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FolderFavouriteScreen> createState() => _FolderFavouriteScreenState();
}

class _FolderFavouriteScreenState extends State<FolderFavouriteScreen> {
  List<FileModel> files_Favourite = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(alignment: Alignment.center, child: SearchWidget()),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Các mục đã thích",
                          style: ResStyle.h2,
                        ),
                      ],
                    ),
                  ),
                  const TabBar(
                    unselectedLabelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelColor: Colors.black,
                    labelColor: Color.fromARGB(255, 18, 173, 250),
                    tabs: <Widget>[
                      Tab(
                        text: "Folders",
                      ),
                      Tab(
                        text: "Files",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        BlocBuilder<FolderFavouriteViewModel, FolderFavouriteState>(
                        builder: (context, state) {
                          if (state is LoadingDataFavouriteSuccessState) {
                            return ListView(
                              children: [
                                for (var folder in state.folders)
                                  FolderFavouriteItem(
                                    folder: folder,
                                  ),
                              ],
                            );
                          } else if (state is LoadingDataFavouriteErrorState) {
                            return Text(state.message);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                        ),
                        BlocBuilder<FileFavouriteViewModel, FileFavouriteState>(
                        builder: (context, state) {
                          if (state.isSuccess) {
                            return ListView(
                              children: [
                                for (var file in state.files)
                                  FileFavouriteItem(
                                    file: file,
                                  ),
                              ],
                            );
                          } else if (state.isFailure) {
                            return Text(state.message);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          );
        }
}
