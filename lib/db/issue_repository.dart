import 'package:app_hackaton/db/database_helper.dart';
import 'package:app_hackaton/data/models/issue_model.dart';

class IssueRepository {
  final db = DatabaseHelper.instance;

  Future<void> initializeTable() async {
    final exists = await db.tableExists('issues');
    if (!exists) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS issues (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL,
          description TEXT,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          imagePath TEXT,
          status TEXT DEFAULT 'pending',
          user_id INTEGER,
          is_anonymous INTEGER DEFAULT 0,
          created_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');
    }
  }

  Future<int> insertIssue(Issue issue) async {
    await initializeTable();
    return await db.insert('issues', issue.toMap());
  }

  Future<List<Issue>> getAllIssues() async {
    await initializeTable();
    final maps = await db.query('issues', orderBy: 'created_at DESC');
    return maps.map((map) => Issue.fromMap(map)).toList();
  }

  Future<List<Issue>> getIssuesByStatus(String status) async {
    await initializeTable();
    final maps = await db.query(
      'issues',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Issue.fromMap(map)).toList();
  }

  Future<List<Issue>> getIssuesByType(String type) async {
    await initializeTable();
    final maps = await db.query(
      'issues',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Issue.fromMap(map)).toList();
  }

  Future<List<Issue>> getIssuesByUser(int userId) async {
    await initializeTable();
    final maps = await db.query(
      'issues',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Issue.fromMap(map)).toList();
  }

  Future<int> updateIssueStatus(int issueId, String newStatus) async {
    await initializeTable();
    return await db.update(
      'issues',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [issueId],
    );
  }

  Future<int> updateIssue(Issue issue) async {
    await initializeTable();
    return await db.update(
      'issues',
      issue.toMap(),
      where: 'id = ?',
      whereArgs: [issue.id],
    );
  }

  Future<int> deleteIssue(int issueId) async {
    await initializeTable();
    return await db.delete(
      'issues',
      where: 'id = ?',
      whereArgs: [issueId],
    );
  }

  Future<Issue?> getIssueById(int issueId) async {
    await initializeTable();
    final maps = await db.query(
      'issues',
      where: 'id = ?',
      whereArgs: [issueId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Issue.fromMap(maps.first);
  }
}
