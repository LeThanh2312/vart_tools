import 'package:flutter/material.dart';
import 'package:vart_tools/routes.dart';
import '../../res/app_constants.dart';
import 'widgets/circle_chart_widget.dart';
import 'widgets/list_file_widget.dart';
import 'widgets/search_widget.dart';

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
                        Navigator.of(context).pushNamed(Routes.recycle_bin);
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
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.camera);
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
                margin: const EdgeInsets.only(top: 10,bottom: 30),
                child: CircleChartWidget(),
              ),
              const ListFile()
            ],
          ),
        ),
      ),
    );
  }
}
