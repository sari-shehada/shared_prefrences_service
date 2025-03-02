import 'package:shared_prefrences_service/enums/shared_prefs_operation_mode.dart';

class UnknownException {
  UnknownException({
    required this.operationMode,
    required this.originalExceptionMessage,
  }) {
    message =
        '''Unknown Exception Occurred When Calling SharedPreferencesService -> ${operationMode.operationModeAsString}
        Original Exception Message: $originalExceptionMessage''';
  }

  final SharedPrefsOperationMode operationMode;
  final String originalExceptionMessage;
  late final String message;
}
