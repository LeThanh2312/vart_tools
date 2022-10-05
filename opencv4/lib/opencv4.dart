import 'package:flutter/foundation.dart';

import 'opencv4_platform_interface.dart';

class Opencv4 {
  Future<String?> getPlatformVersion() async {
    return await Opencv4Platform.instance.getPlatformVersion();
  }

  Future<String?> getOpenCVVersion() async {
    return await Opencv4Platform.instance.getOpenCVVersion();
  }

  Future<dynamic> rotate(Uint8List byteData, int angle) async {
    return await Opencv4Platform.instance.rotate(byteData, angle);
  }
}
