import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefrences_service/exceptions/invalid_data_type_exception.dart';

import 'package:shared_prefrences_service/shared_prefrences_service.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  final instance = await SharedPreferencesService.init();

  group('Set Value Tests', () {
    test('setValue should handle bool values', () async {
      final key = TestKeyEnum.setValueTestKey;
      final bool value = true;

      final result = await instance.setValue(key: key, value: value);

      expect(result, true);
    });

    test('setValue should handle String values', () async {
      final key = TestKeyEnum.setValueTestKey;
      final value = 'test';

      final result = await instance.setValue(key: key, value: value);

      expect(result, true);
    });
    test('setValue should handle int values', () async {
      final key = TestKeyEnum.setValueTestKey;
      final value = 1;

      final result = await instance.setValue(key: key, value: value);

      expect(result, true);
    });
    test('setValue should handle double values', () async {
      final key = TestKeyEnum.setValueTestKey;
      final value = 1.0;

      final result = await instance.setValue(key: key, value: value);

      expect(result, true);
    });
    test('setValue should handle List<String> values', () async {
      final key = TestKeyEnum.setValueTestKey;
      final value = ['apple', 'mango'];

      final result = await instance.setValue(key: key, value: value);

      expect(result, true);
    });

    test('setValue should throw InvalidDataTypeException on unsupported types',
        () async {
      final key = TestKeyEnum.setValueTestKey;
      final value = DateTime.now();

      expect(
        () async => await instance.setValue(key: key, value: value),
        throwsA(isA<InvalidDataTypeException>()),
      );
    });
  });
  group('Get Value Tests', () {
    final bool boolValue = true;
    final int intValue = 10;
    final double doubleValue = 10.0;
    final String stringValue = 'Apple';
    final List<String> stringListValue = ['Apple', 'Mango'];
    setUpAll(() async {
      await instance.setValue(key: TestKeyEnum.getBoolKey, value: boolValue);
      await instance.setValue(key: TestKeyEnum.getIntKey, value: intValue);
      await instance.setValue(
          key: TestKeyEnum.getDoubleKey, value: doubleValue);
      await instance.setValue(
          key: TestKeyEnum.getStringKey, value: stringValue);
      await instance.setValue(
          key: TestKeyEnum.getStringListKey, value: stringListValue);
    });
    test('getValue should handle bool values', () {
      final result = instance.getValue<bool>(key: TestKeyEnum.getBoolKey);

      expect(result, boolValue);
    });

    test('getValue should handle int values', () {
      final result = instance.getValue<int>(key: TestKeyEnum.getIntKey);

      expect(result, intValue);
    });

    test('getValue should handle double values', () {
      final result = instance.getValue<double>(key: TestKeyEnum.getDoubleKey);

      expect(result, doubleValue);
    });

    test('getValue should handle String values', () {
      final result = instance.getValue<String>(key: TestKeyEnum.getStringKey);

      expect(result, stringValue);
    });

    test('getValue should handle List<String> values', () {
      final result =
          instance.getValue<List<String>>(key: TestKeyEnum.getStringListKey);

      expect(result, stringListValue);
    });
    test('getValue should return null if value doesn\'t exist', () {
      final result = instance.getValue<bool>(key: TestKeyEnum.noValueKey);

      expect(result, null);
    });
  });
  group('Clear Value Tests', () {
    test('clearValue should handle clearing a value', () async {
      final bool boolValue = true;
      await instance.setValue(
          key: TestKeyEnum.clearValueTestKey, value: boolValue);
      final result =
          await instance.clearValue(key: TestKeyEnum.clearValueTestKey);

      expect(result, true);
    });
    test('clearValue should return false when key doesn\'t exist', () async {
      final result =
          await instance.clearValue(key: TestKeyEnum.clearValueTestKey);

      expect(result, false);
    });
  });
  group('Clear All Values Tests', () {
    setUpAll(() async {
      await instance.setValue(key: TestKeyEnum.getBoolKey, value: false);
      await instance.setValue(key: TestKeyEnum.getIntKey, value: 10);
      await instance.setValue(key: TestKeyEnum.getDoubleKey, value: 3.14);
    });
    test('clearAll should clear all keys', () async {
      final result = await instance.clearAll();

      expect(result, true);
    });
  });
  group('Key Exists Tests', () {
    setUpAll(() async {
      await instance.setValue(key: TestKeyEnum.getBoolKey, value: false);
    });
    test('should return true for a key that exists', () async {
      final result = instance.keyExists(key: TestKeyEnum.getBoolKey);

      expect(result, true);
    });
    test('should return false for a key that does not exist', () async {
      final result = instance.keyExists(key: TestKeyEnum.getIntKey);

      expect(result, false);
    });
  });

  //TODO: Add keyExists tests
}

enum TestKeyEnum {
  setValueTestKey,
  getBoolKey,
  getIntKey,
  getStringKey,
  getDoubleKey,
  getStringListKey,
  noValueKey,
  clearValueTestKey,
}
