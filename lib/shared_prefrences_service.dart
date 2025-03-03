import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefrences_service/enums/shared_prefs_operation_mode.dart';
import 'package:shared_prefrences_service/exceptions/invalid_data_type_exception.dart';
import 'package:shared_prefrences_service/models/shared_preferences_service_settings.dart';

//TODO: Add tests
//TODO: Enable to ability to toggle logging feature
//TODO: Try to refactor
class SharedPreferencesService {
  ///Main & only singleton constructor
  SharedPreferencesService({
    required SharedPreferences prefs,
    required this.settings,
  }) : _plugin = prefs;

  //Static members
  //
  ///The instance that exposes the service APIs
  static late SharedPreferencesService instance;

  ///Used to avoid initializing the service more than once during
  /// the application's lifecycle
  static bool _isInitialized = false;
  //
  //End of static members

  //Local memebers
  //
  ///Used to configure settings for the service like logging in development mode
  SharedPreferencesServiceSettings settings;

  ///The primary plugin that powers the package's functionality
  final SharedPreferences _plugin;
  //
  //End of local members

  //Methods
  //
  //Static Methods
  //
  ///Used to initialize the service, assigns the value of `instance` which
  ///can be later used to access the API.
  ///
  ///MUST be called and awaited before calling any methods from the package
  static Future<SharedPreferencesService> init({
    SharedPreferencesServiceSettings? settings,
  }) async {
    if (_isInitialized) return instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    instance = SharedPreferencesService(
      prefs: prefs,
      settings: settings ?? SharedPreferencesServiceSettings(),
    );
    _isInitialized = true;
    return instance;
  }

  //Local methods
  ///Used to set a value at a given key (an enum must be created at app level and passed into this method)
  ///This method can handle insertion of the following data types:
  ///
  ///`bool` `String` `int` `double` `List<String>`
  ///
  ///Any other data type should be handled at the app level and transformed into one
  ///of the supported data types in order for the call to succeed
  ///
  ///Returns `true` to indicate the success of the insertion or `false` if an error occurs
  ///at package level without an exception being thrown
  ///
  ///Throws `InvalidDataTypeException` on non-supported types
  Future<bool> setValue<T>({required Enum key, required T value}) async {
    try {
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
          operationMode: SharedPrefsOperationMode.write);
    } on InvalidDataTypeException catch (e) {
      _log(e.message);
      rethrow;
    } catch (e) {
      _logUnknownException(
        operationMode: SharedPrefsOperationMode.write,
        originalExceptionMessage: e.toString(),
      );
      rethrow;
    }
  }

  ///Used to log error messages to the debug console if logging is enabled for the package
  ///in the `settings` property of the `init` function
  void _log(String message) {
    if (settings.shouldEnableLoggingInDevelopment) {
      log(message);
    }
  }

  ///Used to log unknown exceptions that may be thrown by the inner plugin if logging in enabled
  void _logUnknownException({
    required SharedPrefsOperationMode operationMode,
    required String originalExceptionMessage,
  }) {
    _log(
      '''Unknown Exception Occurred When Calling SharedPreferencesService -> ${operationMode.operationModeAsString}
        Original Exception Message: $originalExceptionMessage''',
    );
  }

  //TODO: Continue documenting
  T? getValue<T>({required Enum key}) {
    try {
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
    } on InvalidDataTypeException catch (e) {
      _log(e.message);
      rethrow;
    } catch (e) {
      _logUnknownException(
        operationMode: SharedPrefsOperationMode.read,
        originalExceptionMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<bool> clearAll() async {
    try {
      bool clearingRes = await _plugin.clear();
      if (clearingRes) {
        _log(
            'SharedPreferencesService -> clearAll() -> Clear Shared Preferences Succeeded');
      } else {
        _log(
            'SharedPreferencesService -> clearAll() -> Clear Shared Preferences Failed With An Exception');
      }
      return clearingRes;
    } catch (e) {
      _logUnknownException(
        operationMode: SharedPrefsOperationMode.clearAll,
        originalExceptionMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<bool> clearValue({required Enum key}) async {
    try {
      if (!keyExists(key: key)) {
        throw Exception('Cannot Clear A Non Existing Key: "${key.toString()}"');
      }
      bool clearingRes = await _plugin.remove(key.toString());
      if (clearingRes) {
        log('SharedPreferencesService -> clearValue() -> Clear Shared Preferences Succeeded');
      } else {
        log('SharedPreferencesService -> clearValue() -> Clear Shared Preferences Failed With An Exception');
      }
      return clearingRes;
    } catch (e) {
      log('SharedPreferencesService -> clearValue() -> Clear Shared Preferences Failed With An Exception');
      return false;
    }
  }

  bool keyExists({required Enum key}) {
    try {
      bool keyFound = _plugin.containsKey(key.toString());
      if (!keyFound) {
        log('SharedPreferencesService -> keyExists() -> No Existing Item With Key: $key');
      }
      return keyFound;
    } catch (e) {
      log('SharedPreferencesService -> keyExists() -> Failed With An Exception');
      return false;
    }
  }
}
