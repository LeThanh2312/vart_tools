import 'package:flutter/material.dart';
import 'package:vart_tools/feature/folder/view/folder_screen.dart';
import '../../common/enum/tab_item.dart';
import '../../routes.dart';
import '../favourite/favurite_screen.dart';
import '../file/FileScreen.dart';
import '../home/home_screen.dart';
import '../setting/SettingScreen.dart';

class BottomNavigationBarMainScreen extends StatefulWidget {
  const BottomNavigationBarMainScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarMainScreen> createState() =>
      _BottomNavigationBarMainScreenState();
}

class _BottomNavigationBarMainScreenState
    extends State<BottomNavigationBarMainScreen> {
  TabItem _currentTab = TabItem.home;

  void updateTabSelection(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _currentTab != TabItem.home,
            child: HomeScreen(),
          ),
          Offstage(
            offstage: _currentTab != TabItem.file,
            child: const FolderScreen(),
          ),
          Offstage(
            offstage: _currentTab != TabItem.favourite,
            child: const FavouriteScreen(),
          ),
          Offstage(
            offstage: _currentTab != TabItem.setting,
            child: const SettingScreen(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pushNamed(Routes.camera);
        },
        elevation: 4.0,
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: const Icon(Icons.photo_camera),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  updateTabSelection(TabItem.home);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.home,
                  color: _currentTab == TabItem.home
                      ? Colors.blue.shade900
                      : Colors.grey.shade400,
                ),
              ),
              IconButton(
                onPressed: () {
                  updateTabSelection(TabItem.file);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.file_open,
                  color: _currentTab == TabItem.file
                      ? Colors.blue.shade900
                      : Colors.grey.shade400,
                ),
              ),
              //to leave space in between the bottom app bar items and below the FAB
              const SizedBox(
                width: 50.0,
              ),
              IconButton(
                onPressed: () {
                  updateTabSelection(TabItem.favourite);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.favorite,
                  color: _currentTab == TabItem.favourite
                      ? Colors.blue.shade900
                      : Colors.grey.shade400,
                ),
              ),
              IconButton(
                onPressed: () {
                  updateTabSelection(TabItem.setting);
                },
                iconSize: 27.0,
                icon: Icon(
                  Icons.settings,
                  color: _currentTab == TabItem.setting
                      ? Colors.blue.shade900
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
