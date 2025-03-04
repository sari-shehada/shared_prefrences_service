// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shared_preferences/shared_preferences.dart';

class KeyExists {
  KeyExists({
    required SharedPreferences plugin,
  }) : _plugin = plugin;
  final SharedPreferences _plugin;

  bool call({
    required Enum key,
  }) {
    return _plugin.containsKey(key.toString());
  }
}
