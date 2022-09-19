import 'package:flutter/material.dart';
import '../../../utilities/extentions/enum/chart_item.dart';
import 'package:pie_chart/pie_chart.dart';

class CircleChartWidget extends StatelessWidget {
  CircleChartWidget({Key? key}) : super(key: key);

  List<ChartItem> listChartItem = [
    ChartItem.folder,
    ChartItem.image,
    ChartItem.pdf,
    ChartItem.word
  ];

  final dataMap = <String, double>{
    ChartItem.folder.name: 5,
    ChartItem.image.name: 3,
    ChartItem.pdf.name: 2,
    ChartItem.word.name: 2,
  };

  final colorList = <Color>[
    ChartItem.folder.color,
    ChartItem.image.color,
    ChartItem.pdf.color,
    ChartItem.word.color,
  ];

  final ChartType _chartType = ChartType.ring;

  // ignore: prefer_final_fields
  bool _showLegendsInRow = false;

  final bool _showLegends = true;

  @override
  Widget build(BuildContext context) {
    return chart();
  }

  String centerText = '1620Mb/5GB \n (32,4 %)';

  Widget chart() {
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 20,
      chartRadius: 200,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType!,
      centerText: centerText,
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: LegendPosition.right,
        showLegends: _showLegends,
        legendShape: BoxShape.circle,
        legendTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: false,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
      ),
      ringStrokeWidth: 20,
      emptyColor: Colors.grey,
      gradientList: null,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
      ],
      baseChartColor: Colors.transparent,
    );
  }
}
