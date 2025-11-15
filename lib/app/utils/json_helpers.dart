import 'package:semesta/app/utils/logger.dart';

T? safeParse<T>(dynamic data, T Function(Map<String, dynamic> json) fromJson) {
  if (data == null) return null;
  if (data is! Map) return null;

  return fromJson(Map<String, dynamic>.from(data));
}

T castToMap<T>(dynamic data, T Function(Map<String, dynamic> json) fromJson) {
  return fromJson(Map<String, dynamic>.from(data));
}

T? parseModel<T>(dynamic data, T Function(Map<String, dynamic> json) fromJson) {
  if (data is Map) return fromJson(Map<String, dynamic>.from(data));
  return null;
}

List<T> parseJsonList<T>(
  dynamic data,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (data is List) {
    try {
      return data
          .whereType<Map>() // filters only valid maps
          .map((e) => fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e, s) {
      HandleLogger('⚠️ JSON parse error in parseJsonList', error: e, stack: s);
      return [];
    }
  }

  return [];
}

dynamic parseTo(data, [bool isList = true]) {
  return isList
      ? List<String>.from(data ?? [])
      : Map<String, dynamic>.from(data ?? []);
}
