import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'opencv4_platform_interface.dart';

/// An implementation of [Opencv4Platform] that uses method channels.
class MethodChannelOpencv4 extends Opencv4Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('opencv4');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getOpenCVVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getOpenCVVersion');
    return version;
  }

  @override
  Future rotate(Uint8List byteData, int angle) async {
    return await methodChannel.invokeMethod<dynamic>(
        'rotate', {'byteData': byteData, 'angle': angle});
  }

  @override
  Future blur(Uint8List byteData, List<double> kernelSize,
      List<double> anchorPoint, int borderType) async {
    final dynamic result = await methodChannel.invokeMethod('blur', {
      'byteData': byteData,
      'kernelSize': kernelSize,
      'anchorPoint': anchorPoint,
      'borderType': borderType
    });

    /// Function returns the response from method channel
    return result;
  }

  @override
  Future warpPerspectiveTransform(Uint8List byteData,
      {required List sourcePoints,
      required List destinationPoints,
      required List<double> outputSize}) async {
    final dynamic result =
        await methodChannel.invokeMethod('warpPerspectiveTransform', {
      'byteData': byteData,
      'sourcePoints': sourcePoints,
      'destinationPoints': destinationPoints,
      'outputSize': outputSize
    });
    return result;
  }
}
