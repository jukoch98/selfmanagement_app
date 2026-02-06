import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/shopping_local_datasource.dart';
import '../../data/repositories/shopping_repository_impl.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/shopping_repository.dart';

/// Provider for DataSource (Singleton)
final shoppingDataSourceProvider = Provider<ShoppingLocalDataSource>((ref) {
  return ShoppingLocalDataSource();
});

/// Provider for Repository
/// Uses DataSource providers as dependencies
final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  final dataSource = ref.watch(shoppingDataSourceProvider);
  return ShoppingRepositoryImpl(dataSource);
});

/// StateNotifier for Shopping List State Management
/// Manages the list of all shopping items and their status
class ShoppingListNotifier extends StateNotifier<AsyncValue<List<ShoppingItem>>> {
  final ShoppingRepository _repository;
  final Uuid _uuid = const Uuid();
  
  ShoppingListNotifier(this._repository) : super(const AsyncValue.loading()) {
    // Load automatically at startup
    loadItems();
  }
  
  /// Loads all items from the database
  Future<void> loadItems() async {
    state = const AsyncValue.loading();
    try {
      final items = await _repository.getAllItems();
      state = AsyncValue.data(items);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// Adds a new item
  Future<void> addItem(String name, {int quantity = 1}) async {
    try {
      final newItem = ShoppingItem(
        id: _uuid.v4(),
        name: name,
        quantity: quantity,
        isChecked: false,
        createdAt: DateTime.now(),
      );
      
      await _repository.addItem(newItem);
      await loadItems(); // Reload list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// Toggles the checked status of an item
  Future<void> toggleItem(String id) async {
    try {
      await _repository.toggleItemChecked(id);
      await loadItems();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// Deletes an item
  Future<void> deleteItem(String id) async {
    try {
      await _repository.deleteItem(id);
      await loadItems();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// Updates an item
  Future<void> updateItem(ShoppingItem item) async {
    try {
      await _repository.updateItem(item);
      await loadItems();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// Deletes all checked items
  Future<void> deleteCheckedItems() async {
    try {
      await _repository.deleteCheckedItems();
      await loadItems();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for the Shopping List State
final shoppingListProvider = StateNotifierProvider<ShoppingListNotifier, AsyncValue<List<ShoppingItem>>>((ref) {
  final repository = ref.watch(shoppingRepositoryProvider);
  return ShoppingListNotifier(repository);
});