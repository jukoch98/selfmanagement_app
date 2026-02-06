import '../entities/shopping_item.dart';

/// Repository Interface (Abstract Class)
/// Defines WHICH operations are possible, but not HOW they are implemented.
abstract class ShoppingRepository {
  /// Returns all shopping list items
  Future<List<ShoppingItem>> getAllItems();
  
  /// Adds a new element
  Future<void> addItem(ShoppingItem item);
  
  /// Updates an existing element
  Future<void> updateItem(ShoppingItem item);
  
  /// Deletes an item based on its ID
  Future<void> deleteItem(String id);
  
  /// Toggles the checked status of an element
  Future<void> toggleItemChecked(String id);
  
  /// Deletes all checked items
  Future<void> deleteCheckedItems();
}