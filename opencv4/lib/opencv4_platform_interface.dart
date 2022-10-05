import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'opencv4_method_channel.dart';

abstract class Opencv4Platform extends PlatformInterface {
  /// Constructs a Opencv4Platform.
  Opencv4Platform() : super(token: _token);

  static final Object _token = Object();

  static Opencv4Platform _instance = MethodChannelOpencv4();

  /// The default instance of [Opencv4Platform] to use.
  ///
  /// Defaults to [MethodChannelOpencv4].
  static Opencv4Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Opencv4Platform] when
  /// they register themselves.
  static set instance(Opencv4Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getOpenCVVersion() {
    throw UnimplementedError('openCVVersion() has not been implemented.');
  }

  Future<dynamic> rotate(Uint8List byteData, int angle) {
    throw UnimplementedError('openCVVersion() has not been implemented.');
  }

  Future<dynamic> blur(Uint8List byteData, List<double> kernelSize,
      List<double> anchorPoint, int borderType) {
    throw UnimplementedError('openCVVersion() has not been implemented.');
  }

  Future<dynamic> warpPerspectiveTransform(Uint8List byteData,
      {required List sourcePoints,
      required List destinationPoints,
      required List<double> outputSize}) {
    throw UnimplementedError('openCVVersion() has not been implemented.');
  }
}
