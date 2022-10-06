import 'package:flutter/material.dart';
import 'package:vart_tools/common/animation/scale_animation.dart';
import '../../../res/app_constants.dart';
import '../../camera/view/camera_screen.dart';
import '../../folder/view/folder_trash_screen.dart';
import '../widgets/circle_chart_widget.dart';
import '../widgets/list_file_widget.dart';
import '../widgets/search_widget.dart';
import 'package:camera/camera.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          margin: const EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            bottom: defaultPadding,
            top: defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchWidget(),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideRightRoute(page: const FolderTrashScreen()),
                        );
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.delete_forever_sharp),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Thùng rác'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        await availableCameras().then((value) => Navigator.push(
                            context,
                            SlideRightRoute(
                                page: CameraScreen(cameras: value))));
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.credit_card),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Thẻ ID'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: const [
                          Icon(Icons.folder),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Thư mục'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: CircleChartWidget(),
              ),
              const ListFileWidget()
            ],
          ),
        ),
      ),
    );
  }
}
