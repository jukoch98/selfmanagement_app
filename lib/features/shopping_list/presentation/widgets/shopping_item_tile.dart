import 'package:flutter/material.dart';
import '../../domain/entities/shopping_item.dart';

/// Widget for a single shopping list item
class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  
  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),

      // Swipe right = Delete
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(

          // Checkbox to tick
          leading: Checkbox(
            value: item.isChecked,
            onChanged: (_) => onToggle(),
          ),

          // Name of item (crossed out when checked)
          title: Text(
            item.name,
            style: TextStyle(
              decoration: item.isChecked ? TextDecoration.lineThrough : null,
              color: item.isChecked ? Colors.grey : null,
            ),
          ),

          // Display quantity if > 1
          subtitle: item.quantity > 1
              ? Text('Quantity: ${item.quantity}')
              : null,

          // Edit Button
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }
}