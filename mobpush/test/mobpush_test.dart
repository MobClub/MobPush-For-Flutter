import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mobpush/mobpush.dart';

void main() {
  const MethodChannel channel = MethodChannel('mobpush');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
    // expect(await Mobpush.platformVersion, '42');
  // });
}
