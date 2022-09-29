import 'package:flutter/material.dart';
import 'package:vart_tools/feature/file/view_model/file_bloc.dart';
import 'package:vart_tools/feature/file/view_model/file_favourite_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_favourite_bloc.dart';
import 'package:vart_tools/feature/folder/view_model/folders_trash_bloc.dart';
import 'package:vart_tools/routes.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feature/bottom_navigation_bar_main/view/bottom_navigation_bar_main_screen.dart';
import 'feature/camera/view_model/camera_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => CameraPictureBloc(),
      ),
      BlocProvider(
        create: (context) => FoldersViewModel(),
      ),
      BlocProvider(
        create: (context) => FolderTrashViewModel(),
      ),
      BlocProvider(
        create: (context) => FolderFavouriteViewModel(),
      ),
      BlocProvider(
        create: (context) => RedirectFileScreenViewModel(),
      ),
      BlocProvider(
        create: (context) => FilesViewModel(),
      ),
      BlocProvider(
        create: (context) => FirstInitScreenViewModel(),
      ),
      BlocProvider(
        create: (context) => FileFavouriteViewModel(),
      ),
    ], child: const MyApp()),
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
