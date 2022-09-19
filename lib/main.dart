import 'package:flutter/material.dart';
import 'package:vart_tools/routes.dart';
import 'package:sizer/sizer.dart';

import 'feature/bottom_navigation_bar_main/bottom_navigation_bar_main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Vart Tools',
          routes: Routes.routes,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const BottomNavigationBarMainScreen(),
        );
      },
    );
  }
}
