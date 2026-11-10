import 'package:shared_preferences/shared_preferences.dart';
import '../models/issue.dart';

class IssueStorage {
  static const _key = 'citizen_issues_v1';
  final SharedPreferencesAsync _prefs;

  IssueStorage({SharedPreferencesAsync? preferences})
      : _prefs = preferences ?? SharedPreferencesAsync();

  Future<List<Issue>> getAll() async {
    final raw = await _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final issues = Issue.decodeList(raw);
      issues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return issues;
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    }
  }

  Future<void> save(Issue newIssue) async {
    final issues = await getAll();
    issues.insert(0, newIssue);
    await _prefs.setString(_key, Issue.encodeList(issues));
  }

  Future<void> update(Issue updated) async {
    final issues = await getAll();
    final index = issues.indexWhere((issue) => issue.id == updated.id);
    if (index < 0) return;
    issues[index] = updated;
    await _prefs.setString(_key, Issue.encodeList(issues));
  }

  Future<void> delete(String id) async {
    final issues = await getAll();
    issues.removeWhere((issue) => issue.id == id);
    await _prefs.setString(_key, Issue.encodeList(issues));
  }
}
