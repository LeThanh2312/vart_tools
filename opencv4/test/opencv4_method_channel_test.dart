import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencv4/opencv4_method_channel.dart';

void main() {
  MethodChannelOpencv4 platform = MethodChannelOpencv4();
  const MethodChannel channel = MethodChannel('opencv4');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
