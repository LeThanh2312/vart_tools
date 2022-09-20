import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vart_tools/res/app_color.dart';

enum ChartItem { folder, image, pdf, word}

extension ChartItemExtention on ChartItem? {
  String get name {
    switch (this) {
      case ChartItem.folder:
        return 'Thư mục';
      case ChartItem.image:
        return 'Ảnh';
      case ChartItem.pdf:
        return 'PDF';
      case ChartItem.word:
        return 'Word';
      default:
    }
    return '';
  }

  Color get color {
    switch (this) {
      case ChartItem.folder:
        return AppColors.colorFolder;
      case ChartItem.image:
        return AppColors.colorImage;
      case ChartItem.pdf:
        return AppColors.colorPDF;
      case ChartItem.word:
        return  AppColors.colorWord;
      default:
    }
    return AppColors.primary;
  }

  int get icon {
    switch (this) {
      case ChartItem.folder:
        return 0xe2a3;
      case ChartItem.image:
        return 0xe332;
      case ChartItem.pdf:
        return 0xe4c0;
      case ChartItem.word:
        return 0xf058;
      default:
    }
    return 0;
  }
}