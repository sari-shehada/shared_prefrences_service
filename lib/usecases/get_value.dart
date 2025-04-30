import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_service/exceptions/invalid_data_type_exception.dart';
import 'package:shared_preferences_service/enums/shared_prefs_operation_mode.dart';

class GetValue {
  const GetValue({
    required SharedPreferences plugin,
  }) : _plugin = plugin;
  final SharedPreferences _plugin;
  T? call<T>({required Enum key}) {
    if (T == bool) {
      return _plugin.getBool(key.toString()) as T?;
    }
    if (T == String) {
      return _plugin.getString(key.toString()) as T?;
    }
    if (T == int) {
      return _plugin.getInt(key.toString()) as T?;
    }
    if (T == double) {
      return _plugin.getDouble(key.toString()) as T?;
    }
    if (T == List<String>) {
      return _plugin.getStringList(key.toString()) as T?;
    }
    throw InvalidDataTypeException(
        operationMode: SharedPrefsOperationMode.read);
  }
}
