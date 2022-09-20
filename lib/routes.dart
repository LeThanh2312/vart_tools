import 'package:flutter/material.dart';

import 'feature/bottom_navigation_bar_main/bottom_navigation_bar_main_screen.dart';
import 'feature/camera/view/camera_screen.dart';
import 'feature/home/view/detail_size_screen.dart';
import 'feature/recycle_bin/recycle_bin_screen.dart';

class Routes {
  Routes._();

  //static variables
  // ignore: constant_identifier_names
  static const String bottom_navigation_bar = '/bottom_navigation_bar_main';
  static const String camera = '/camera';
  static const String recycle_bin = '/recycle_bin';
  static const String detail_screen = '/detail_screen';

  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    bottom_navigation_bar: (BuildContext context) => const BottomNavigationBarMainScreen(),
    camera: (BuildContext context) => const CameraScreen(),
    recycle_bin: (BuildContext context) => const RecycleBinScreen(),
  };
}