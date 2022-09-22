import 'package:flutter/material.dart';
import 'package:vart_tools/routes.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/bottom_navigation_bar_main/view/bottom_navigation_bar_main_screen.dart';
import 'feature/camera/view_model/camera_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CameraPictureBloc(),
        )
      ],
      child: const MyApp(),
    ),
  );
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
