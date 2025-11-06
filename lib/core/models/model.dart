import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// A generic abstract base model for Firebase.
abstract class Model<T extends Model<T>> extends Equatable {
  final String id;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const Model({required this.id, this.createdAt, this.updatedAt});

  /// Forces subclasses to implement a copyWith method
  T copyWith();

  /// Convert the model into a serializable Map (for Firebase)
  Map<String, dynamic> toMap();

  /// Create a model instance from Firestore data
  factory Model.fromFirestore(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return fromJson({
      ...json,
      'created_at': json['created_at'] ?? Timestamp.now(),
      'updated_at': json['updated_at'] ?? Timestamp.now(),
    });
  }

  /// Convert to JSON string
  String toJson() => jsonEncode(toMap());

  /// Convert Firestore Timestamp → DateTime safely
  static DateTime? parseTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;

    return null;
  }

  /// Convert DateTime → Timestamp safely
  static Timestamp? toTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    if (value is DateTime) return Timestamp.fromDate(value);

    return null;
  }

  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
