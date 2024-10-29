import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../Screens/Admin/Profile/profile_modal.dart';
import 'models.dart';


class LocalDatabaseService {
  static final LocalDatabaseService _instance = LocalDatabaseService._internal();
  Database? _database;

  factory LocalDatabaseService() {
    return _instance;
  }

  LocalDatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'local_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDB,
    );
  }

  Future<void> _onCreateDB(Database db, int version) async {
    // Create tables for brands and customers
    await db.execute('''
      CREATE TABLE brands(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image TEXT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        address TEXT,
        balance INTEGER,
        balanceLimit INTEGER,
        code INTEGER,
        createdBy TEXT,
        email TEXT,
        mobileNumber TEXT,
        name TEXT,
        priceControlLevel INTEGER,
        zipCode TEXT
      )
    ''');

    // Similarly, create tables for Groups and Users
  }

  Future<void> saveBrands(List<Brand> brands) async {
    final db = await database;
    await db.delete('brands'); // Clear existing data
    for (var brand in brands) {
      await db.insert('brands', brand.toMap());
    }
  }

  Future<List<Brand>> getBrands() async {
    final db = await database;
    final result = await db.query('brands');
    return result.map((map) => Brand.fromMap(map)).toList();
  }

  Future<void> saveCustomers(List<Customer> customers) async {
    final db = await database;
    await db.delete('customers'); // Clear existing data
    for (var customer in customers) {
      await db.insert('customers', customer.toMap());
    }
  }

  Future<List<Customer>> getCustomers() async {
    final db = await database;
    final result = await db.query('customers');
    return result.map((map) => Customer.fromMap(map)).toList();
  }

  // Similarly, implement methods for saving and fetching Groups and Users
}
