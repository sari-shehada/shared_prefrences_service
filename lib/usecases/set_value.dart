import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefrences_service/enums/shared_prefs_operation_mode.dart';
import 'package:shared_prefrences_service/exceptions/invalid_data_type_exception.dart';

class SetValue<T> {
  const SetValue({
    required this.params,
    required SharedPreferences plugin,
  }) : _plugin = plugin;
  final SharedPreferences _plugin;
  final SetValueParams<T> params;

  Future<bool> call() async {
    final key = params.key;
    final value = params.value;
    if (value is bool) {
      return await _plugin.setBool(key.toString(), value);
    }
    if (value is String) {
      return await _plugin.setString(key.toString(), value);
    }
    if (value is int) {
      return await _plugin.setInt(key.toString(), value);
    }
    if (value is double) {
      return await _plugin.setDouble(key.toString(), value);
    }
    if (value is List<String>) {
      return await _plugin.setStringList(key.toString(), value);
    }
    throw InvalidDataTypeException(
      operationMode: SharedPrefsOperationMode.write,
    );
  }
}

class SetValueParams<T> {
  SetValueParams({
    required this.key,
    required this.value,
  });

  final Enum key;
  final T value;
}
