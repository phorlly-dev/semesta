import 'package:semesta/app/utils/json_helpers.dart';
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
    super.id,
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
  }) => ProductModel(
    id: id,
    name: name ?? this.name,
    price: price ?? this.price,
    userId: userId ?? this.userId,
    status: status ?? this.status,
    description: description ?? this.description,
    location: location ?? this.location,
    images: images ?? this.images,
    createdAt: createdAt,
    updatedAt: DateTime.now(),
  );

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    final map = Model.convertJsonKeys(json, toCamelCase: true);
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      userId: map['userId'],
      status: map['status'],
      description: map['description'],
      location: map['location'],
      images: parseTo(map['images']),
      createdAt: Model.createOrUpdate(map),
      updatedAt: Model.createOrUpdate(map, false),
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
    final data = {
      ...general,
      'name': name,
      'price': price,
      'userId': userId,
      'status': status,
      'description': description,
      'location': location,
      'images': images,
    };
    return Model.convertJsonKeys(data);
  }
}
