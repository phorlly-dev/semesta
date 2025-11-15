import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// A generic abstract base model for Firebase.
abstract class Model<T extends Model<T>> extends Equatable {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Model({required this.id, this.createdAt, this.updatedAt});

  /// Forces subclasses to implement a copyWith method
  T copyWith();

  /// Convert the model into a serializable Map (for Firebase)
  Map<String, dynamic> toMap();

  //Get data from db
  static DateTime? createOrUpdate(
    Map<String, dynamic> map, [
    bool isCreate = true,
  ]) {
    return isCreate
        ? toDateTime(map['createdAt'])
        : toDateTime(map['updatedAt']);
  }

  //Set data to db
  Map<String, dynamic> get general => {
    'id': id,
    'createdAt': toEpoch(createdAt ?? DateTime.now()),
    'updatedAt': toEpoch(updatedAt ?? DateTime.now()),
  };

  /// Convert to JSON string
  String toJson() => jsonEncode(toMap());

  /// Convert Firestore Timestamp or JSON int → DateTime
  static DateTime? toDateTime(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) return value.toDate(); // Firestore Timestamp
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value); // Epoch int
    }
    if (value is String) return DateTime.tryParse(value); // ISO string
    if (value is DateTime) return value; // Already DateTime

    return null;
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
  static int? toEpoch(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) return value.millisecondsSinceEpoch;
    if (value is DateTime) return value.millisecondsSinceEpoch;

    return null;
  }

  /// Convert DateTime or Timestamp to ISO-8601 string (for readable JSON)
  static String? toIsoString(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is DateTime) return value.toIso8601String();

    return null;
  }

  static Map<String, dynamic> convertJsonKeys(
    Map<String, dynamic> data, {
    bool toCamelCase = false,
  }) {
    final Map<String, dynamic> result = {};

    data.forEach((key, value) {
      String newKey = key;

      if (toCamelCase) {
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

        // Special rule: convert 'id' endings to '_id'
        if (newKey.endsWith('_id') == false &&
            key.toLowerCase().endsWith('id')) {
          newKey = newKey.replaceFirst(RegExp(r'id$'), '_id');
        }
      }

      if (value is Map<String, dynamic>) {
        result[newKey] = convertJsonKeys(value, toCamelCase: toCamelCase);
      } else if (value is List) {
        result[newKey] = value
            .map(
              (e) => e is Map<String, dynamic>
                  ? convertJsonKeys(e, toCamelCase: toCamelCase)
                  : e,
            )
            .toList();
      } else {
        result[newKey] = value;
      }
    });

    return result;
  }

  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
