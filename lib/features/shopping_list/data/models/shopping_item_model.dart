import '../../domain/entities/shopping_item.dart';

/// Model = Entity + Serialization/Deserialization
/// Extends Entity with functions for database/API communication
class ShoppingItemModel extends ShoppingItem {
  const ShoppingItemModel({
    required super.id,
    required super.name,
    super.quantity,
    super.isChecked,
    required super.createdAt,
  });
  
  /// Factory Constructor: Creates model from map (e.g., from SQLite)
  factory ShoppingItemModel.fromMap(Map<String, dynamic> map) {
    return ShoppingItemModel(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      isChecked: (map['is_checked'] as int) == 1, // SQLite stores bools as 0/1
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
  
  /// Converts model to map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'is_checked': isChecked ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  /// Creates model from entity
  factory ShoppingItemModel.fromEntity(ShoppingItem entity) {
    return ShoppingItemModel(
      id: entity.id,
      name: entity.name,
      quantity: entity.quantity,
      isChecked: entity.isChecked,
      createdAt: entity.createdAt,
    );
  }
}