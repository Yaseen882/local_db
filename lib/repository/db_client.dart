import 'package:database_practise_flutter/domain/model/product.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBClient {
  static DBClient? _instance;
  static Database? _database;
  static const dbName = 'Test.db';
  static const version = 1;

  /// SingleTon Class
  DBClient._();

  factory DBClient() {
    _instance ??= DBClient._();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return await initDB();
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: version,
      onCreate: (db, version) {
        return db.execute(Product.createTable);
      },
    );
  }
}
