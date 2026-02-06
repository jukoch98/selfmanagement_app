import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/shopping_item_model.dart';

/// DataSource = Direct communication with data source (here SQLite)
/// Encapsulates all SQL operations
class ShoppingLocalDataSource {
  Database? _database;
  
  /// Singleton Pattern
  static final ShoppingLocalDataSource _instance = ShoppingLocalDataSource._internal();
  factory ShoppingLocalDataSource() => _instance;
  ShoppingLocalDataSource._internal();
  
  /// Lazy Initialization: Database is only opened when needed
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  /// Initializes the database
  Future<Database> _initDatabase() async {
    // Determine path to database
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.dbName);
    
    // Open database (will be created if it does not exist)
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDatabase,
    );
  }
  
  /// Creates the tables on first launch
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.shoppingItemsTable} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        is_checked INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
  }
  
  /// CRUD operations
  
  Future<List<ShoppingItemModel>> getAllItems() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.shoppingItemsTable,
      orderBy: 'created_at DESC', // Newest first
    );
    
    return maps.map((map) => ShoppingItemModel.fromMap(map)).toList();
  }
  
  Future<void> insertItem(ShoppingItemModel item) async {
    final db = await database;
    await db.insert(
      AppConstants.shoppingItemsTable,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<void> updateItem(ShoppingItemModel item) async {
    final db = await database;
    await db.update(
      AppConstants.shoppingItemsTable,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
  
  Future<void> deleteItem(String id) async {
    final db = await database;
    await db.delete(
      AppConstants.shoppingItemsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<void> deleteCheckedItems() async {
    final db = await database;
    await db.delete(
      AppConstants.shoppingItemsTable,
      where: 'is_checked = ?',
      whereArgs: [1],
    );
  }
  
  Future<ShoppingItemModel?> getItemById(String id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.shoppingItemsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return ShoppingItemModel.fromMap(maps.first);
  }
}