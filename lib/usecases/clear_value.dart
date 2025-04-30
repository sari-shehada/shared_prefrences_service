import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_service/shared_preferences_service.dart';
import 'package:shared_preferences_service/usecases/logger.dart';

class ClearValue {
  final SharedPreferences _plugin;
  final Logger logger;
  ClearValue({
    required this.logger,
    required SharedPreferences plugin,
  }) : _plugin = plugin;

  Future<bool> call({
    required Enum key,
  }) async {
    if (!SharedPreferencesService.instance.keyExists(key: key)) {
      return false;
    }
    bool clearingRes = await _plugin.remove(key.toString());
    if (clearingRes) {
      logger
          .log('SharedPreferencesService -> clearValue() -> Command Succeeded');
    } else {
      logger.log(
          'SharedPreferencesService -> clearValue() -> Command Failed (Perhaps the key does not exist in the first place)');
    }
    return clearingRes;
  }
}
