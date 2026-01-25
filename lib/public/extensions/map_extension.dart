import 'package:get/get.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/utils/type_def.dart';

extension MapX<T> on RxMap<String, T> {
  void set(String key, T value) {
    this[key] = value;
    refresh();
  }

  T? get(String key) => this[key];
}

extension MapListX<T> on RxMap<String, List<T>> {
  void setList(String key, List<T> value) {
    this[key] = List<T>.from(value);
    refresh();
  }

  /// Ensure list exists
  List<T> ensure(String key) => this[key] ?? const [];

  /// Remove item by condition
  void removeFrom(String key, PropsCallback<T, bool> fn) {
    this[key] = ensure(key).where((x) => !fn(x)).toList();
    refresh();
  }

  /// Append a single item
  void addTo(String key, [T? item]) {
    this[key] = [...ensure(key), ?item];
    refresh();
  }

  void toggle(
    String currentId,
    String targetId, {
    required bool isActive,
    T? data,
    bool hasMessage = false,
  }) {
    if (isActive) {
      // remove
      removeFrom(targetId, (current) => (current as dynamic).id == currentId);
      if (hasMessage) CustomToast.warning('Removed from List');
    } else {
      // add
      addTo(targetId, data);
      if (hasMessage) CustomToast.info('Added to List');
    }

    refresh();
  }
}
