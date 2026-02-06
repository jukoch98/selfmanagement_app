import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../datasources/shopping_local_datasource.dart';
import '../models/shopping_item_model.dart';

/// Repository implementation
/// Connects domain layer with data layer
/// Converts between entities and models
class ShoppingRepositoryImpl implements ShoppingRepository {
  final ShoppingLocalDataSource _localDataSource;
  
  ShoppingRepositoryImpl(this._localDataSource);
  
  @override
  Future<List<ShoppingItem>> getAllItems() async {
    // Retrieves models from the DataSource and returns them as entities
    final models = await _localDataSource.getAllItems();
    return models; // Models are a subclass of Entity and can be returned directly
  }
  
  @override
  Future<void> addItem(ShoppingItem item) async {
    final model = ShoppingItemModel.fromEntity(item);
    await _localDataSource.insertItem(model);
  }
  
  @override
  Future<void> updateItem(ShoppingItem item) async {
    final model = ShoppingItemModel.fromEntity(item);
    await _localDataSource.updateItem(model);
  }
  
  @override
  Future<void> deleteItem(String id) async {
    await _localDataSource.deleteItem(id);
  }
  
  @override
  Future<void> toggleItemChecked(String id) async {
    // Load item, reverse status, save
    final item = await _localDataSource.getItemById(id);
    if (item != null) {
      final updatedItem = ShoppingItemModel(
        id: item.id,
        name: item.name,
        quantity: item.quantity,
        isChecked: !item.isChecked,
        createdAt: item.createdAt,
      );
      await _localDataSource.updateItem(updatedItem);
    }
  }
  
  @override
  Future<void> deleteCheckedItems() async {
    await _localDataSource.deleteCheckedItems();
  }
}