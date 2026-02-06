/// Entity = Business entity without external dependencies
/// Represents a shopping list item
class ShoppingItem {

  /// Properties
  final String id;
  final String name;
  final int quantity;
  final bool isChecked;
  final DateTime createdAt;
  
  /// Constructor
  const ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.isChecked = false,
    required this.createdAt
  });
  
  /// Method for creating a copy with modified values
  /// Important for immutability (unchangeable objects)
  ShoppingItem copyWith({
    String? id,
    String? name,
    int? quantity,
    bool? isChecked,
    DateTime? createdAt
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  /// Overrides the default toString() method for readable output during debugging
  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, quantity: $quantity, isChecked: $isChecked)';
  }
  
  /// Defines when two ShoppingItem objects are considered “equal”
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem && other.id == id;
  }
  
  /// Must be overridden if == is overridden. Required for HashMaps/Sets.
  /// Items with the same ID have the same HashCode.
  @override
  int get hashCode => id.hashCode;
}