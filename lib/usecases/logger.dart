import 'dart:developer' as developer;

import 'package:shared_prefrences_service/enums/shared_prefs_operation_mode.dart';
import 'package:shared_prefrences_service/shared_prefrences_service.dart';

class Logger {
  const Logger({
    required this.operationMode,
  });

  final SharedPrefsOperationMode operationMode;
  static const String _prefix = 'SharedPreferencesService ->';

  ///Used to log error messages to the debug console if logging is enabled for the package
  ///in the `settings` property of the `init` function
  void log(
    String message,
  ) {
    if (SharedPreferencesService
        .instance.settings.shouldEnableLoggingInDevelopment) {
      developer.log(_constructMessage(message));
    }
  }

  ///Used to log unknown exceptions that may be thrown by the inner plugin if logging is enabled
  void logUnknown(String originalExceptionMessage) {
    log(
      '''$_prefix *Unknown Exception* Occurred When Calling: ${operationMode.operationModeAsString}
        Original Exception Message: $originalExceptionMessage''',
    );
  }

  String _constructMessage(String message) {
    return '$_prefix ${operationMode.operationModeAsString} $message';
  }
}
