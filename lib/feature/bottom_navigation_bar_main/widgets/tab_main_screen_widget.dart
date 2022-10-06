import 'package:flutter/material.dart';

import '../../../common/enum/tab_item.dart';
import '../../file/view/file_screen.dart';
import '../../file/view_model/file_bloc.dart';
import '../../folder/view/folder_favourite_screen.dart';
import '../../folder/view/folder_screen.dart';
import '../../home/view/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../setting/settings_screen.dart';

class TabMainScreenWidget extends StatefulWidget {
  const TabMainScreenWidget({Key? key, required this.currentTab})
      : super(key: key);
  final TabItem currentTab;

  @override
  State<TabMainScreenWidget> createState() => _TabMainScreenWidgetState();
}

class _TabMainScreenWidgetState extends State<TabMainScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: widget.currentTab != TabItem.home,
          child: const HomeScreen(),
        ),
        Offstage(
          offstage: widget.currentTab != TabItem.file,
          child: const FolderScreen(),),
        Offstage(
          offstage: widget.currentTab != TabItem.favourite,
          child: const FolderFavouriteScreen(),
        ),
        Offstage(
          offstage: widget.currentTab != TabItem.setting,
          child: const SettingsScreen(),
        ),
      ],
    );
  }
}
