import 'package:semesta/public/functions/logger.dart';
import 'package:semesta/public/utils/type_def.dart';

/// Safely parses a single JSON object into type [T].
T? safeParse<T extends Object>(dynamic data, Defo<AsMap, T> from) {
  if (data == null || data is! Map) return null;

  return handler(
    () => from(AsMap.from(data)),
    type: MessageInfo.warning,
    message: 'Parsing to safeParse',
  );
}

T parseEnum<T extends Enum>(dynamic data, List<T> values) {
  if (data == null || data is! String || data.isEmpty) return values[0];

  return values.firstWhere((e) => e.name == data, orElse: () => values[0]);
}

/// Parses a map directly, assuming it's valid JSON.
/// Throws if invalid — use only for trusted sources.
T castToMap<T extends Object>(dynamic data, Defo<AsMap, T> from) {
  if (data is! Map) {
    throw ArgumentError('Expected a Map but got ${data.runtimeType}');
  }

  return handler(
    () => from(AsMap.from(data)),
    type: MessageInfo.warning,
    message: 'Parsing to castMap',
  );
}

/// Safely parses a list of JSON objects into a list of [T].
List<T> parseJsonList<T extends Object>(dynamic data, Defo<AsMap, T> from) {
  if (data == null || data is! List) return [];

  return handler(
    () => data.whereType<Map>().map((e) => from(AsMap.from(e))).toList(),
    type: MessageInfo.warning,
    message: 'Parsing to JSON list',
  );
}

/// Parses to either a List
AsList parseToList(dynamic data) => handler(
  () => AsList.from(data ?? const []),
  type: MessageInfo.warning,
  message: 'Parsing to list',
);

/// Parses to either a Map
AsMap parseToMap(dynamic data) => handler(
  () => AsMap.from(data ?? const {}),
  type: MessageInfo.warning,
  message: 'Parsing to map',
);

Mapper<T> getMap<T>(List<T> items, Defo<T, String> selector) => {
  for (var item in items) selector(item): item,
};

List<T> getSelected<T>(AsList values, Ask<AsMap> data, Defo<AsMap, T> from) {
  if (data.docs.isEmpty || values.isEmpty) return const [];

  final map = {for (var doc in data.docs) doc.id: from(doc.data())};
  return values.where(map.containsKey).map((id) => map[id]!).toList();
}

List<T> getMore<T>(Ask<AsMap> data, Defo<AsMap, T> from) {
  return handler(() {
    return data.docs.isNotEmpty
        ? data.docs.map<T>((e) => from(e.data())).toList()
        : const [];
  }, message: 'Something when wrong');
}

T getOne<T>(dynamic value, Defo<AsMap, T> from) {
  return from(value.data() ?? const {});
}

enum MessageInfo { info, warning, error }

R handler<R extends Object>(
  Callback<R> callback, {
  AsError? onError,
  String? message,
  MessageInfo type = MessageInfo.error,
}) {
  try {
    return callback();
  } catch (error, stack) {
    onError?.call(error, stack);
    Exception(error);
    StateError(error.toString());

    switch (type) {
      case MessageInfo.info:
        HandleLogger.info(
          "ℹ️ Caught info in: $message",
          error: error,
          stack: stack,
        );
        break;

      case MessageInfo.warning:
        HandleLogger.warning(
          "⚠️ Caught warning in: $message",
          error: error,
          stack: stack,
        );
        break;

      default:
        HandleLogger.error(
          "❌ Caught error in: $message",
          error: error,
          stack: stack,
        );
    }

    rethrow;
  }
}
