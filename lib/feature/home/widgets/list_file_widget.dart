import 'package:flutter/material.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:sizer/sizer.dart';
import '../../../command/enum/chart_item.dart';
import '../view/detail_size_screen.dart';

class ListFile extends StatefulWidget {
  const ListFile({Key? key}) : super(key: key);

  @override
  State<ListFile> createState() => _ListFileState();
}

class _ListFileState extends State<ListFile> {
  List<ChartItem> listFile = [
    ChartItem.folder,
    ChartItem.image,
    ChartItem.pdf,
    ChartItem.word
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.greenLight,
      ),
      child: SizedBox(
        height: 27.0.h,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: listFile.map((ChartItem e) {
            int index = listFile.indexOf(e) + 1;
            return itemFile(e, index, listFile.length);
          }).toList(),
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
                    IconData(e.icon, fontFamily: 'MaterialIcons'),
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
                        MaterialPageRoute(
                          builder: (context) => DetailSizeScreen(
                            typeDetail: e,
                          ),
                        ),
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
