import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('mobpush_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await MobpushPlugin.platformVersion, '42');
  });
}
