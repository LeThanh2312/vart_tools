import 'package:flutter/material.dart';
import 'package:vart_tools/common/animation/scale_animation.dart';
import 'package:vart_tools/common/enum/chart_item.dart';
import 'package:vart_tools/res/app_color.dart';
import '../view/detail_size_screen.dart';

class ListFileWidget extends StatefulWidget {
  const ListFileWidget({Key? key}) : super(key: key);

  @override
  State<ListFileWidget> createState() => _ListFileWidgetState();
}

class _ListFileWidgetState extends State<ListFileWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.greenLight,
      ),
      child: SizedBox(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: ChartItem.values.map((ChartItem e) {
              int index = ChartItem.values.indexOf(e) + 1;
              return itemFile(e, index, ChartItem.values.length);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget itemFile(ChartItem e, int index, int length) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    e.icon,
                    color: AppColors.yellow,
                    size: 41,
                  ),
                  const SizedBox(width: 10),
                  Text(e.name),
                ],
              ),
              Row(
                children: [
                  const Text('600Mb/2GB'),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideRightRoute(page: DetailSizeScreen(
                          typeDetail: e,
                        ),)
                      );
                    },
                    child: const Icon(Icons.keyboard_arrow_right, size: 44),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ignore: unrelated_type_equality_checks
        (index == length)
            ? Container()
            : const Divider(
                height: 1,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              )
      ],
    );
  }
}
