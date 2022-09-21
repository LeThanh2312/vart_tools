import 'package:flutter/material.dart';
import 'package:vart_tools/res/app_color.dart';
import 'package:sizer/sizer.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../common/enum/chart_item.dart';

class DetailSizeScreen extends StatefulWidget {
  const DetailSizeScreen({Key? key, required this.typeDetail}) : super(key: key);
  final ChartItem typeDetail;

  @override
  State<DetailSizeScreen> createState() => _DetailSizeScreenState();
}

class _DetailSizeScreenState extends State<DetailSizeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 30,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(
                      widget.typeDetail.icon,
                      color: AppColors.yellow,
                      size: 50,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.typeDetail.name),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 7),
                            child: const Text('Dung lượng: '),
                          ),
                          const Text('Tổng File: ')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20, bottom: 5),
                      child: const Text(
                        '600Mb/2Gb',
                      ),
                    ),
                    LinearPercentIndicator(
                      width: 80.0.w,
                      animation: true,
                      lineHeight: 25.0,
                      animationDuration: 2500,
                      percent: 600 / 2048,
                      alignment: MainAxisAlignment.center,
                      barRadius: const Radius.circular(7),
                      progressColor: widget.typeDetail.color,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 65.0.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.yellow,
                      ),
                      child: const Text(
                        'Xóa bớt files',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.yellow,
                      ),
                      child: const Text(
                        'Mua thêm GB ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
