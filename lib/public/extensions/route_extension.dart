import 'package:go_router/go_router.dart';

extension GoRouterStateX on GoRouterState {
  String pathOrQuery(String key, [bool quering = false]) {
    var params = pathParameters[key];

    if (quering) params = uri.queryParameters[key];
    if (params == null) {
      throw StateError('Invalid params key: $params');
    }

    return params;
  }
}
