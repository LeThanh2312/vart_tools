import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:opencv4/opencv4.dart';
import 'package:opencv4/opencv4_platform_interface.dart';
import 'package:opencv4/opencv4_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOpencv4Platform
    with MockPlatformInterfaceMixin
    implements Opencv4Platform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getOpenCVVersion() => Future.value('42');

  @override
  Future rotate(Uint8List byteData, int angle) {
    // TODO: implement rotate
    throw UnimplementedError();
  }

  @override
  Future blur(Uint8List byteData, List<double> kernelSize,
      List<double> anchorPoint, int borderType) {
    // TODO: implement blur
    throw UnimplementedError();
  }

  @override
  Future warpPerspectiveTransform(Uint8List byteData,
      {required List sourcePoints,
      required List destinationPoints,
      required List<double> outputSize}) {
    // TODO: implement warpPerspectiveTransform
    throw UnimplementedError();
  }
}

void main() {
  final Opencv4Platform initialPlatform = Opencv4Platform.instance;

  test('$MethodChannelOpencv4 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpencv4>());
  });

  test('getPlatformVersion', () async {
    Opencv4 opencv4Plugin = Opencv4();
    MockOpencv4Platform fakePlatform = MockOpencv4Platform();
    Opencv4Platform.instance = fakePlatform;

    expect(await opencv4Plugin.getPlatformVersion(), '42');
  });
}
