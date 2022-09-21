import 'package:flutter/material.dart';

import 'feature/bottom_navigation_bar_main/view/bottom_navigation_bar_main_screen.dart';
import 'feature/camera/view/camera_screen.dart';
import 'feature/recycle_bin/view/recycle_bin_screen.dart';

class Routes {
  Routes._();

  static const String bottomNavigationBar = '/bottom_navigation_bar_main';
  static const String camera = '/camera';
  static const String recycleBin = '/recycle_bin';
  static const String detailScreen = '/detail_screen';

  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    bottomNavigationBar: (BuildContext context) => const BottomNavigationBarMainScreen(),
    camera: (BuildContext context) => const CameraScreen(),
    recycleBin: (BuildContext context) => const RecycleBinScreen(),
  };
}