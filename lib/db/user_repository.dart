import 'package:app_hackaton/db/database_helper.dart';

class UserRepository {
  final db = DatabaseHelper.instance;

  Future<void> initializeTable() async {
    final exists = await db.tableExists('users');
    if (!exists) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL,
          is_authenticated INTEGER DEFAULT 0,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
      ''');
    }
  }

  /// Returns true if there's an authenticated user.
  Future<bool> isAuthenticated() async {
    await initializeTable();
    final users = await db.query('users', where: 'is_authenticated = ?', whereArgs: [1]);
    return users.isNotEmpty;
  }

  /// Optionally get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    await initializeTable();
    final users = await db.query('users', where: 'is_authenticated = ?', whereArgs: [1]);
    return users.isNotEmpty ? users.first : null;
  }

  Future<int?> getAuthenticatedUserId() async {
    final profile = await getUserProfile();
    return profile?['id'] as int?;
  }

  Future<int> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    await initializeTable();
    
    // Check if email already exists
    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    
    if (existing.isNotEmpty) {
      throw Exception('Email already registered');
    }

    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
      'is_authenticated': 1,
    });
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    await initializeTable();
    
    final users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (users.isEmpty) return null;

    // Mark as authenticated
    await db.update(
      'users',
      {'is_authenticated': 1},
      where: 'id = ?',
      whereArgs: [users.first['id']],
    );

    return users.first;
  }

  Future<void> logout() async {
    await initializeTable();
    await db.update(
      'users',
      {'is_authenticated': 0},
      where: 'is_authenticated = ?',
      whereArgs: [1],
    );
  }
}
