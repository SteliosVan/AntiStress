import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SessionService {
  static const _key = 'mindpause_sessions';

  static Future<List<Session>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => Session.fromJson(s)).toList();
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
}
