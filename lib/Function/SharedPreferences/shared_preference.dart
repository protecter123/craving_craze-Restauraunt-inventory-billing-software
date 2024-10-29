// import 'package:shared_preferences/shared_preferences.dart';

// import '../../Utils/Global/global.dart';

// class SharedPreferencesHelper {
//   static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
//   late SharedPreferences _prefs;

//   factory SharedPreferencesHelper() {
//     return _instance;
//   }

//   SharedPreferencesHelper._internal();

//   Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   static Future<void> setValues(Map<String, dynamic> values) async {
//     for (var entry in values.entries) {
//       if (entry.value is String) {
//         await _instance._prefs.setString(entry.key, entry.value);
//       } else if (entry.value is int) {
//         await _instance._prefs.setInt(entry.key, entry.value);
//       } else if (entry.value is bool) {
//         await _instance._prefs.setBool(entry.key, entry.value);
//       }
//        else if {
//         await _instance._prefs.setStringList(entry.key, []);
//       }
//     }
//   }

//   static Future<Map<String, dynamic>> getValues(List<String> keys) async {
//     Map<String, dynamic> values = {};

//     for (var key in keys) {
//       String? stringValue = _instance._prefs.getString(key);
//       if (stringValue != null) {
//         values[key] = stringValue;
//       } else {
//         int? intValue = _instance._prefs.getInt(key);
//         if (intValue != null) {
//           values[key] = intValue;
//         } else {
//           bool? boolValue = _instance._prefs.getBool(key);
//           if (boolValue != null) {
//             values[key] = boolValue;
//           }
//         }
//       }
//     }

//     return values;
//   }
// }
