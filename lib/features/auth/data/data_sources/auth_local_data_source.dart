import 'package:point_zero/core/data/db_helper.dart';
import 'package:point_zero/core/errors/exceptions.dart';
import 'package:point_zero/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper dbHelper;

  AuthLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      } else {
        // No match found
        throw AuthException(message: 'Invalid username or password');
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw LocalDatabaseException(message: 'Database error occurred during login');
    }
  }
}