import 'package:database_practise_flutter/domain/model/product.dart';
import 'package:database_practise_flutter/repository/db_client.dart';
import 'package:flutter/cupertino.dart';

class ProductDBClient {
  /// Here We Can Create CRUD Operation Methods...To Achieve Path To Access Database...
  Future<int> insertProduct(Product product) async {
    var db = await DBClient().database;
    return await db.insert(Product.tableName, product.toMap());
  }

  Future<int> updateProduct(Product product) async {
    var db = await DBClient().database;
    return await db.update(Product.tableName, product.toMap(),
        where: '${Product.keyId} =?', whereArgs: [product.id]);
  }

  Future<int> deleteProduct(Product product) async {
    var db = await DBClient().database;
    return await db.delete(Product.tableName,
        where: '${Product.keyId} =?', whereArgs: [product.id]);
  }

  Future<Product?> fetchProduct(int productId) async {
    var db = await DBClient().database;
    var result = await db.query(Product.tableName,
        where: '${Product.keyId} =?', whereArgs: [productId]);
    return Product.fromMap(result[0]);
  }

  Future<List<Product>> fetchProducts() async {
    var db = await DBClient().database;
    var result = await db.query(Product.tableName);
    debugPrint('.......................Fetch..............$result');
    return result.map((map) => Product.fromMap(map)).toList();
  }
}
