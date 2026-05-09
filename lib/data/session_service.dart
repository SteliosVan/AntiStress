import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SessionService {
  static const _key = 'mindpause_sessions';

  static Future<List<Session>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final sessions = <Session>[];
    for (final s in raw) {
      try {
        sessions.add(Session.fromJson(s));
      } catch (e) {
        // Skip corrupted entries
        continue;
      }
    }
    return sessions;
  }

  static Future<void> saveSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];
    existing.add(session.toJson());
    await prefs.setStringList(_key, existing);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<List<Session>> getSessionsByExercise(String exerciseId) async {
    final all = await loadSessions();
    return all.where((s) => s.exerciseId == exerciseId).toList();
  }

  static Future<List<Session>> getSessionsInDateRange(DateTime start, DateTime end) async {
    final all = await loadSessions();
    return all.where((s) => !s.date.isBefore(start) && !s.date.isAfter(end)).toList();
  }
}
