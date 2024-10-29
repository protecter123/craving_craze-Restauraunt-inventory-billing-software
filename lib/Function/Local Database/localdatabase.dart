// services/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // Ensure this import is included

import '../../Screens/Admin/Profile/profile_modal.dart';

import 'dart:io';

class DatabaseHelper {
  static final _databaseName = "user_database.db";
  static final _databaseVersion = 1;

  static final table = 'user_table';

  static final columnId = 'id';
  static final columnUId = 'uId';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnAddress = 'address';
  static final columnProfiles = 'profiles';
  static final columnBrands = 'brands';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database; // Use nullable type

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,  // Fixed typo
            $columnUId TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnAddress TEXT NOT NULL,
            $columnProfiles TEXT NOT NULL,
            $columnBrands TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertUser (User user) async {
    Database db = await instance.database;
    return await db.insert(table, {
      columnUId: user.uId,
      columnName: user.name,
      columnEmail: user.email,
      columnAddress: user.address,
      columnProfiles: user.profiles.join(','),  // Assuming profiles is a list of strings
      columnBrands: user.brands.map((brand) => brand.toMap()).join(','), // Assuming brand.toMap() returns a string
    });
  }

  Future<User?> fetchUser (int id) async {  // Return type changed to User?
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;  // Return null if no user found
    }
  }

  Future<int> updateUser (User user) async {
    Database db = await instance.database;
    return await db.update(table, user.toJson(), where: '$columnUId = ?', whereArgs: [user.uId]); // Fixed where clause
  }

  Future<int> deleteUser (int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}