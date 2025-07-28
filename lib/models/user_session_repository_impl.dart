import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_session.dart';
import 'user_session_repository.dart';

/// Concrete implementation of [IUserSessionRepository] using shared_preferences for local storage.
class UserSessionRepository implements IUserSessionRepository {
  /// Storage key for all user sessions.
  static const String _storageKey = 'user_sessions';

  /// Fetches all user sessions from local storage.
  @override
  Future<List<UserSession>> getAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => UserSession.fromJson(e)).toList();
  }

  /// Fetches a single session by [id], or null if not found.
  @override
  Future<UserSession?> getSession(String id) async {
    final sessions = await getAllSessions();
    try {
      return sessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Saves (creates or updates) a session in local storage.
  @override
  Future<void> saveSession(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getAllSessions();
    final idx = sessions.indexWhere((s) => s.id == session.id);
    if (idx >= 0) {
      sessions[idx] = session;
    } else {
      sessions.add(session);
    }
    await prefs.setString(
      _storageKey,
      jsonEncode(sessions.map((s) => s.toJson()).toList()),
    );
  }

  /// Deletes a session by [id] from local storage.
  @override
  Future<void> deleteSession(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getAllSessions();
    sessions.removeWhere((s) => s.id == id);
    await prefs.setString(
      _storageKey,
      jsonEncode(sessions.map((s) => s.toJson()).toList()),
    );
  }
}
