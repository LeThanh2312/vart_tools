import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<FolderFavouriteViewModel>().add(LoadDataFavouriteEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        child: Column(
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
                ],
              ),
            ),
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
            Expanded(
              child:
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
            ),
          ],
        ),
      ),
    );
  }
}
