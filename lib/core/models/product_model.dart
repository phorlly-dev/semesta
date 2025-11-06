import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesta/core/models/model.dart';

class ProductModel extends Model<ProductModel> {
  final String name;
  final int price;
  final String userId;
  final String status;
  final String? description;
  final String? location;
  final List<String> images;

  const ProductModel({
    required this.name,
    required this.price,
    required this.userId,
    required this.status,
    this.description,
    this.location,
    required this.images,
    required super.id,
    super.createdAt,
    super.updatedAt,
  });

  @override
  ProductModel copyWith({
    String? name,
    int? price,
    String? userId,
    String? status,
    String? description,
    String? location,
    List<String>? images,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      description: description ?? this.description,
      location: location ?? this.location,
      images: images ?? this.images,
      createdAt: createdAt,
      updatedAt: Timestamp.now(),
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      userId: map['user_id'],
      status: map['status'],
      description: map['description'],
      location: map['location'],
      images: List<String>.from(map['images'] ?? []),
      createdAt: map['created_at'] ?? Timestamp.now(),
      updatedAt: map['updated_at'] ?? Timestamp.now(),
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    price,
    userId,
    status,
    description,
    location,
    images,
  ];

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'user_id': userId,
      'status': status,
      'description': description,
      'location': location,
      'images': images,
    };
  }
}
