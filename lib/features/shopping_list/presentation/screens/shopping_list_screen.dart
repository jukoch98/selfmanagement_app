import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shopping_providers.dart';
import '../widgets/shopping_item_tile.dart';
import '../widgets/add_item_dialog.dart';

/// Main screen for the shopping list
class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get state from provider
    final shoppingListState = ref.watch(shoppingListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping list'),
        actions: [
          // Button to delete all checked items
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Delete checked items',
            onPressed: () => _showDeleteCheckedDialog(context, ref),
          ),
        ],
      ),
      body: shoppingListState.when(
        // Loading State
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        // Error State
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(shoppingListProvider.notifier).loadItems(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
        // Data State
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No entries',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add an item',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          // Sort unchecked first, then checked
          final sortedItems = [...items]..sort((a, b) {
            if (a.isChecked == b.isChecked) {
              return b.createdAt.compareTo(a.createdAt);
            }
            return a.isChecked ? 1 : -1;
          });
          
          return ListView.builder(
            itemCount: sortedItems.length,
            itemBuilder: (context, index) {
              final item = sortedItems[index];
              return ShoppingItemTile(
                item: item,
                onToggle: () => ref
                    .read(shoppingListProvider.notifier)
                    .toggleItem(item.id),
                onDelete: () => ref
                    .read(shoppingListProvider.notifier)
                    .deleteItem(item.id),
                onEdit: () => _showEditDialog(context, ref, item),
              );
            },
          );
        },
      ),
      // Floating action button for adding
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Displays dialog for adding a new item
  void _showAddDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );
    
    if (result != null) {
      ref.read(shoppingListProvider.notifier).addItem(
        result['name'] as String,
        quantity: result['quantity'] as int,
      );
    }
  }
  
  /// Displays dialog for editing an item
  void _showEditDialog(BuildContext context, WidgetRef ref, item) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddItemDialog(
        initialName: item.name,
        initialQuantity: item.quantity,
        isEdit: true,
      ),
    );
    
    if (result != null) {
      final updatedItem = item.copyWith(
        name: result['name'] as String,
        quantity: result['quantity'] as int,
      );
      ref.read(shoppingListProvider.notifier).updateItem(updatedItem);
    }
  }
  
  /// Displays confirmation dialog for deleting all checked items
  void _showDeleteCheckedDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete checked items?'),
        content: const Text(
          'Are you sure you want to delete all checked items?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      ref.read(shoppingListProvider.notifier).deleteCheckedItems();
    }
  }
}