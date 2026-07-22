import 'package:point_zero/core/data/db_helper.dart';
import 'package:point_zero/core/errors/exceptions.dart';
import 'package:point_zero/features/inventory/data/models/product_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class InventoryLocalDataSource {
  Future<void> addProduct(ProductModel product);
  Future<List<ProductModel>> getProduct();
  Future<bool> checkCodeExists(String code);
  Future<void> deleteProduct(String code);
  Future<void> updateProduct(ProductModel product);
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final DatabaseHelper dbHelper;
  InventoryLocalDataSourceImpl({required this.dbHelper});
  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      final db = await dbHelper.database;

      await db.insert(
        'products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw LocalDatabaseException(
        message: "فشل في إضافة المنتج لقاعدة البيانات",
      );
    }
  }

  @override
  Future<List<ProductModel>> getProduct() async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('products');

      if (maps.isEmpty) {
        return [];
      }
      return maps.map((map) => ProductModel.fromMap(map)).toList();
    } catch (e) {
      throw LocalDatabaseException(
        message: 'فشل في جلب المنتجات من قاعدة البيانات',
      );
    }
  }

  @override
  Future<bool> checkCodeExists(String code) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query(
        'products',
        where: 'code = ?',
        whereArgs: [code],
      );
      return result.isNotEmpty; // سيعيد true إذا كان الكود موجوداً بالفعل
    } catch (e) {
      throw LocalDatabaseException(message: 'فشل التحقق من كود المنتج');
    }
  }

  @override
  Future<void> deleteProduct(String code) async {
    final db = await dbHelper.database;
    await db.delete('products', where: 'code = ?', whereArgs: [code]);
    
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final db = await dbHelper.database;
    await db.update(
      'products',
      product.toMap(),
      where: 'code = ?',
      whereArgs: [product.code],
    );
  }
}
