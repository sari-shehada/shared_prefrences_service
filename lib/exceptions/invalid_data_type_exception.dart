import 'package:shared_preferences_service/enums/shared_prefs_operation_mode.dart';

class InvalidDataTypeException {
  InvalidDataTypeException({
    required this.operationMode,
  }) {
    message =
        'Exception Occurred When Calling SharedPreferencesService -> ${operationMode.operationModeAsString} -> Data Type Not Supported';
  }
  final SharedPrefsOperationMode operationMode;
  late final String message;
}
