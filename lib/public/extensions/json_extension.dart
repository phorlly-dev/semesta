import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/public/functions/func_helper.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

extension AsMapX on AsMap {
  T from<T extends Object>(String key) => this[key];

  DateTime asDate(String key) {
    final value = this[key];
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? now;

    return now;
  }

  String get id => from<String>('id');
  String get name => from<String>('name');
  String get uid => from<String>('uid');
  String get pid => from<String>('pid');
  String asText(String key) => from<String>(key);
  int asInt(String key) => from<int>(key);
  double asDouble(String key) => from<double>(key);
  bool asBool(String key) => from<bool>(key);

  /// A helper method to parse a value from the map as an enum of type T,
  /// using a provided list of enum values, used for fields that store enum values in the database.
  T asEnum<T extends Enum>(String key, List<T> values) {
    return parseEnum<T>(from(key), values);
  }

  /// A helper method to parse a value from the map as an object of type T,
  /// using a provided parsing function, used for fields that store complex objects in the database.
  T asJsons<T extends Object>(String key, Defo<AsMap, T> onValue) {
    return castToMap<T>(from(key), onValue);
  }

  /// A helper method to parse a value from the map as a JSON object of type T,
  /// using a provided parsing function, used for fields that store complex objects in the database.
  AsMap asJson(String key) {
    return parseToMap(from(key));
  }

  /// Parse a value from the map as a list of objects of type T,
  /// using a provided parsing function, used for fields that store arrays of complex objects in the database.
  List<T> asArrays<T extends Object>(String key, Defo<AsMap, T> onValue) {
    return parseJsonList<T>(from(key), onValue);
  }

  /// Parse a value from the map as a list of strings, used for fields that store arrays of strings in the database.
  AsList asArray(String key) => parseToList(from(key));

  // Convenience getters for common fields
  DateTime get created => asDate('created_at');
  DateTime get updated => asDate('updated_at');
  DateTime get deleted => asDate('deleted_at');
  DateTime get lastUsed => asDate('last_used_at');

  /// A helper method to convert a map with snake_case keys into a map with camelCase keys,
  /// or vice versa, used for consistent data formatting when interacting with APIs or databases that use different naming conventions.
  AsMap convert({AsMap? json, bool reverse = false}) {
    final AsMap result = {};
    final data = json ?? this;

    data.forEach((key, value) {
      String newKey = key;

      if (reverse) {
        // ✅ Handle special Mongo/Firestore ID fields
        // snake_case → camelCase
        newKey = key.replaceAllMapped(
          RegExp(r'_([a-z])'),
          (match) => match[1]!.toUpperCase(),
        );
      } else {
        // camelCase → snake_case
        newKey = key.replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match[0]!.toLowerCase()}',
        );
      }

      // Recursion for nested maps/lists
      if (value is AsMap) {
        result[newKey] = convert(json: value, reverse: reverse);
      } else if (value is List) {
        result[newKey] = value
            .map((e) => e is AsMap ? convert(json: e, reverse: reverse) : e)
            .toList();
      } else {
        result[newKey] = value;
      }
    });

    return result;
  }
}
