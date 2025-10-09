import 'package:app_hackaton/db/database_helper.dart';

class UserRepository {
  final db = DatabaseHelper.instance;

  /// Returns true if there's an authenticated user.
  Future<bool> isAuthenticated() async {
    final exists = await db.tableExists('users');
    if (!exists) return false;

    final users = await db.query('users', where: 'is_authenticated = ?', whereArgs: [1]);
    return users.isNotEmpty;
  }

  /// Optionally get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    final users = await db.query('users', where: 'is_authenticated = ?', whereArgs: [1]);
    return users.isNotEmpty ? users.first : null;
  }
}