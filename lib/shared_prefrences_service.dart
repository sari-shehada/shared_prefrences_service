import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefrences_service/enums/shared_prefs_operation_mode.dart';
import 'package:shared_prefrences_service/exceptions/invalid_data_type_exception.dart';
import 'package:shared_prefrences_service/models/shared_preferences_service_settings.dart';
import 'package:shared_prefrences_service/usecases/clear_all.dart';
import 'package:shared_prefrences_service/usecases/clear_value.dart';
import 'package:shared_prefrences_service/usecases/get_value.dart';
import 'package:shared_prefrences_service/usecases/key_exists.dart';
import 'package:shared_prefrences_service/usecases/logger.dart';
import 'package:shared_prefrences_service/usecases/set_value.dart';

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
    return await _exceptionHanldingWrapper(
        operationMode: SharedPrefsOperationMode.write,
        function: (logger) async {
          return await SetValue(
            plugin: _plugin,
            params: SetValueParams(key: key, value: value),
          ).call();
        });
  }

  //TODO: Continue documenting
  T? getValue<T>({required Enum key}) {
    return _exceptionHanldingWrapper(
      operationMode: SharedPrefsOperationMode.read,
      function: (logger) {
        return GetValue(plugin: _plugin).call(key: key);
      },
    );
  }

  Future<bool> clearAll() async {
    return await _exceptionHanldingWrapper(
      operationMode: SharedPrefsOperationMode.clearAll,
      function: (logger) async {
        return await ClearAll(logger: logger, plugin: _plugin).call();
      },
    );
  }

  Future<bool> clearValue({required Enum key}) async {
    return _exceptionHanldingWrapper(
        operationMode: SharedPrefsOperationMode.clearValue,
        function: (logger) {
          return ClearValue(plugin: _plugin, logger: logger).call(key: key);
        });
  }

  bool keyExists({required Enum key}) {
    return _exceptionHanldingWrapper(
      operationMode: SharedPrefsOperationMode.keyExists,
      function: (logger) {
        return KeyExists(plugin: _plugin).call(key: key);
      },
    );
  }

  //TODO: Document
  ReturnType _exceptionHanldingWrapper<ReturnType>({
    required SharedPrefsOperationMode operationMode,
    required ReturnType Function(Logger logger) function,
  }) {
    final logger = Logger(operationMode: operationMode);
    try {
      return function(logger);
    } on InvalidDataTypeException catch (e) {
      logger.log(e.message);
      rethrow;
    } catch (e) {
      logger.logUnknown(e.toString());
      rethrow;
    }
  }
}
