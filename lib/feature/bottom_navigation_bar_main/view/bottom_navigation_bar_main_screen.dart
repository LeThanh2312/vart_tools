import 'package:flutter/material.dart';
import 'package:vart_tools/common/animation/scale_animation.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/file/view_model/file_favourite_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_favourite_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/enum/tab_item.dart';
import '../../camera/view/camera_screen.dart';
import 'package:camera/camera.dart';
import '../widgets/bottom_navigator_bar_main_widget.dart';
import '../widgets/tab_main_screen_widget.dart';

class BottomNavigationBarMainScreen extends StatefulWidget {
  const BottomNavigationBarMainScreen({Key? key, required this.currentTab})
      : super(key: key);
  final TabItem currentTab;

  @override
  State<BottomNavigationBarMainScreen> createState() =>
      _BottomNavigationBarMainScreenState();
}

class _BottomNavigationBarMainScreenState
    extends State<BottomNavigationBarMainScreen> {
  late TabItem _currentTab;
  late bool fileScreenRedirect;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.currentTab;
  }

  @override
  void dispose() {
    super.dispose();
    FocusScope.of(context).unfocus();
  }

  void updateTabSelection(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
      if (_currentTab == TabItem.favourite) {
        context.read<FolderFavouriteViewModel>().add(LoadDataFavouriteEvent());
        context
            .read<FileFavouriteViewModel>()
            .add(LoadDataFilesFavouriteEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: TabMainScreenWidget(
          currentTab: _currentTab,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await availableCameras().then(
              (value) => {
                Navigator.push(
                    context,
                    SlideRightRoute(page: CameraScreen(cameras: value)))
              },
            );
          },
          elevation: 4.0,
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: const Icon(Icons.photo_camera),
          ),
        ),
        bottomNavigationBar: BottomNavigatorBarMainWidget(
          currentTab: _currentTab,
          updateTabSelection: updateTabSelection,
        ));
  }
}
