import 'package:get/get.dart';
import 'package:semesta/app/functions/custom_toast.dart';
import 'package:semesta/app/functions/format.dart';
import 'package:semesta/app/utils/cached_helper.dart';
import 'package:semesta/core/views/helper.dart';

extension Lists<T> on List<T> {
  List<List<T>> chunked(int size) {
    if (size <= 0) throw ArgumentError('Chunk size must be greater than 0');
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }

    return chunks;
  }
}

extension CachedStateX<T extends HasAttributes> on CachedState<T> {
  void set(List<T> initing) {
    assignAll(List<T>.from(initing));
    refresh();
  }

  void merge(List<T> incoming) {
    if (incoming.isEmpty) return;

    // Build lookup from existing items
    final map = <String, T>{for (final item in this) item.currentId: item};

    // Insert / replace with incoming
    for (final item in incoming) {
      map[item.currentId] = item;
    }

    // Sort (newest first, or whatever your rule is)
    final merged = map.values.toList().sortOrder;

    assignAll(merged);
    refresh();
  }

  void append(List<T> incoming) => addAll(incoming);
}

extension ListX<T extends HasAttributes> on List<T> {
  List<T> get rankChronological {
    final list = [...this];
    list.sort((a, b) {
      final dateA = a.created;
      final dateB = b.created;

      // Handle null dates safely
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1; // null dates go to end
      if (dateB == null) return -1;

      return dateB.compareTo(dateA);
    });

    return list;
  }

  List<T> rankFeed(int seed) {
    final copy = [...this];
    copy.sort((a, b) {
      final ra = _rank(a, seed);
      final rb = _rank(b, seed);

      return rb.compareTo(ra);
    });

    return copy;
  }

  double _rank(T p, int seed) {
    final createdAt = p.created ?? now;
    final ageHours = now.difference(createdAt).inMinutes / 60;

    final base = 1 / (1 + ageHours); // freshness
    final jitter = ((p.currentId.hashCode ^ seed) & 0xffff) / 0xffff;

    return base * 0.6 + jitter * 0.4;
  }

  List<T> get sortOrder {
    final list = [...this];
    list.sort((a, b) => b.created?.compareTo(a.created ?? now) ?? 0);

    return list;
  }
}

extension RxListX<T> on RxList<T> {
  void setList(List<T> items) {
    assignAll(List<T>.from(items));
    refresh();
  }

  void addTo(T data) {
    insert(0, data);
    refresh();
  }

  void merge(List<T> incoming) {
    final seen = <String>{};
    final result = <T>[];

    for (final item in [...incoming, ...this]) {
      final id = (item as dynamic).id;
      if (seen.add(id)) result.add(item);
    }

    setList(result);
  }

  void addToAll(List<T> items) {
    insertAll(0, items);
    refresh();
  }

  void append(List<T> incoming) {
    addAll(incoming);
  }

  void removeFrom(String pkId) {
    removeWhere((e) => (e as dynamic).id == pkId);
    refresh();
  }

  void toggle(
    String pkId, {
    required bool isActive,
    required T data,
    bool hasMessage = false,
  }) {
    if (isActive) {
      // remove
      removeFrom(pkId);
      if (hasMessage) CustomToast.warning('Removed from List');
    } else {
      // add
      addTo(data);
      if (hasMessage) CustomToast.info('Added to List');
    }

    refresh();
  }
}
