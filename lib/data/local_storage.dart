import 'package:hive/hive.dart';
import 'package:app_hackaton/data/models/issue_model.dart';

class LocalStorage {
  static final _box = Hive.box('issues');

  static Future<void> addIssue(Issue issue) async {
    await _box.add(issue.toMap());
  }

  static List<Issue> getIssues() {
    return _box.values.map<Issue>((e) => Issue.fromMap(Map<String, dynamic>.from(e))).toList();
  }
}