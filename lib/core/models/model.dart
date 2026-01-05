import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:semesta/app/utils/type_def.dart';

/// A generic abstract base model for Firebase.
abstract class Model<T extends Model<T>> extends Equatable {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const Model({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Forces subclasses to implement a copyWith method
  T copy();

  /// Convert the model into a serializable Map (for Firebase)
  AsMap to();

  //Get data from db
  static DateTime createOrUpdate(AsMap map, [bool isCreate = true]) {
    return isCreate
        ? toDateTime(map['createdAt'])
        : toDateTime(map['updatedAt']);
  }

  //Set data to db
  AsMap get general => {
    'id': id,
    'createdAt': toEpoch(createdAt),
    'updatedAt': toEpoch(updatedAt),
  };

  /// Convert to JSON string
  String toJson() => jsonEncode(to());

  /// Convert Firestore Timestamp or JSON int → DateTime
  static DateTime toDateTime(dynamic value) {
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();

    return DateTime.now();
  }

  /// Convert DateTime or Firestore Timestamp → Firestore Timestamp
  static Timestamp? toTimestamp(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) return value;
    if (value is DateTime) return Timestamp.fromDate(value);
    if (value is int) return Timestamp.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return Timestamp.fromDate(parsed);
    }

    return null;
  }

  /// Convert DateTime or Timestamp to millisecondsSinceEpoch (JSON-safe)
  static int toEpoch(dynamic value) {
    if (value is Timestamp) return value.millisecondsSinceEpoch;
    if (value is DateTime) return value.millisecondsSinceEpoch;

    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Convert DateTime or Timestamp to ISO-8601 string (for readable JSON)
  static String? toIsoString(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is DateTime) return value.toIso8601String();

    return DateTime.now().toIso8601String();
  }

  static AsMap convertJsonKeys(AsMap data, [bool toCamelCase = false]) {
    final AsMap result = {};

    data.forEach((key, value) {
      String newKey = key;

      if (toCamelCase) {
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
        result[newKey] = convertJsonKeys(value, toCamelCase);
      } else if (value is List) {
        result[newKey] = value
            .map((e) => e is AsMap ? convertJsonKeys(e, toCamelCase) : e)
            .toList();
      } else {
        result[newKey] = value;
      }
    });

    return result;
  }

  @override
  List<Object?> get props => [id, createdAt, updatedAt, deletedAt];
}
