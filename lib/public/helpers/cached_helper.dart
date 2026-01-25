import 'package:get/get.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/helpers/class_helper.dart';

class CachedState<T> extends RxList<T> {}

class CachedPayload<T extends HasAttributes> {
  final Map<String, List<T>> _cache = {};

  /// Retrieves items for a key, returns empty list if not found
  List<T> get(String key) => _cache[key] ?? const [];

  /// Sets items for a key (creates defensive copy)
  void set(String key, List<T> items) {
    _cache[key] = List<T>.from(items);
  }

  /// Appends items to existing list
  void append(String key, List<T> items) {
    if (items.isEmpty) return;

    final existing = _cache[key];
    if (existing == null) {
      _cache[key] = List<T>.from(items);
    } else {
      existing.addAll(items);
    }
  }

  /// Merges new items with existing, deduplicates, and sorts by creation date (newest first)
  void merge(String key, List<T> items) {
    final previous = _cache[key] ?? const [];

    // Use Map for O(1) lookups instead of Set
    final itemsById = <String, T>{};

    // Add new items first (priority)
    for (final item in items) {
      itemsById[item.currentId] = item;
    }

    // Add existing items (won't overwrite newer ones)
    for (final item in previous) {
      itemsById.putIfAbsent(item.currentId, () => item);
    }

    // Sort by creation date (newest → oldest)
    final result = itemsById.values.toList()
      ..sort((a, b) {
        final dateA = a.created;
        final dateB = b.created;

        // Handle null dates safely
        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1; // null dates go to end
        if (dateB == null) return -1;

        return dateB.compareTo(dateA);
      });

    _cache[key] = result;
  }

  /// Adds items to existing list (null-safe)
  void add(String key, List<T>? items) {
    if (items == null || items.isEmpty) return;

    final existing = _cache[key];
    if (existing == null) {
      _cache[key] = List<T>.from(items);
    } else {
      existing.addAll(items);
    }
  }

  /// Removes item by ID from a specific key
  void removeById(String key, String itemId) {
    final existing = _cache[key];
    if (existing == null) return;

    existing.removeWhere((item) => item.currentId == itemId);

    // Clean up empty lists
    if (existing.isEmpty) {
      _cache.remove(key);
    }
  }

  /// Clears all items for a specific key
  void clear(String key) => _cache.remove(key);

  /// Clears entire cache
  void clearAll() => _cache.clear();

  /// Toggles item presence in target list
  void toggle(
    String key,
    String itemId, {
    required bool isActive,
    List<T>? items,
    bool showMessage = false,
  }) {
    if (isActive) {
      removeById(key, itemId);
      if (showMessage) CustomToast.warning('Removed from List');
    } else {
      add(key, items);
      if (showMessage) CustomToast.info('Added to List');
    }
  }

  /// Returns number of cached keys
  int get keyCount => _cache.length;

  /// Returns total number of items across all keys
  int get totalItemCount =>
      _cache.values.fold(0, (sum, list) => sum + list.length);

  /// Checks if key exists and has items
  bool hasItems(String key) => _cache[key]?.isNotEmpty ?? false;
}
