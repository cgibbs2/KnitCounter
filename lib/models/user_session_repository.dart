import 'user_session.dart';

/// Abstract repository interface for CRUD operations on user sessions.
abstract class IUserSessionRepository {
  /// Returns all user sessions.
  Future<List<UserSession>> getAllSessions();

  /// Returns a single session by [id], or null if not found.
  Future<UserSession?> getSession(String id);

  /// Saves (creates or updates) a session.
  Future<void> saveSession(UserSession session);

  /// Deletes a session by [id].
  Future<void> deleteSession(String id);
}
