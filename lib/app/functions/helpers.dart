import 'package:semesta/app/functions/logger.dart';
import 'package:semesta/app/utils/type_def.dart';

/// Safely parses a single JSON object into type [T].
T? safeParse<T>(dynamic data, T Function(AsMap json) fromJson) {
  if (data == null || data is! Map) return null;

  try {
    return fromJson(AsMap.from(data));
  } catch (e, s) {
    HandleLogger.warn(
      '⚠️ Error parsing JSON in safeParse',
      message: e,
      stack: s,
    );
    return null;
  }
}

/// Parses a map directly, assuming it's valid JSON.
/// Throws if invalid — use only for trusted sources.
T castToMap<T>(dynamic data, T Function(AsMap json) fromJson) {
  if (data is! Map) {
    throw ArgumentError('Expected a Map but got ${data.runtimeType}');
  }

  return fromJson(AsMap.from(data));
}

/// Safely parses a list of JSON objects into a list of [T].
List<T> parseJsonList<T>(dynamic data, T Function(AsMap json) fromJson) {
  if (data == null || data is! List) return [];

  try {
    return data.whereType<Map>().map((e) => fromJson(AsMap.from(e))).toList();
  } catch (e, s) {
    HandleLogger.warn('⚠️ Error parsing JSON list', message: e, stack: s);
    return [];
  }
}

/// Parses to either a List
List<String> parseToList(dynamic data) {
  try {
    return List<String>.from(data ?? const []);
  } catch (e, s) {
    HandleLogger.warn('⚠️ Error in parse to list', message: e, stack: s);
    return const [];
  }
}

/// Parses to either a Map
AsMap parseToMap(dynamic data) {
  try {
    return AsMap.from(data ?? const {});
  } catch (e, s) {
    HandleLogger.warn('⚠️ Error in parse to map', message: e, stack: s);
    return const {};
  }
}
