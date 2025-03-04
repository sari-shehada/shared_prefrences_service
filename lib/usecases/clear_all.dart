import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_prefrences_service/usecases/logger.dart';

class ClearAll {
  final Logger logger;
  final SharedPreferences _plugin;
  ClearAll({
    required this.logger,
    required SharedPreferences plugin,
  }) : _plugin = plugin;

  Future<bool> call() async {
    bool clearingRes = await _plugin.clear();
    if (clearingRes) {
      logger.log('Clear Shared Preferences Succeeded');
    }
    return clearingRes;
  }
}
