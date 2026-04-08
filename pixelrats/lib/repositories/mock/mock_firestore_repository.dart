import '../firestore_repository.dart';

class MockFirestoreRepository implements FirestoreRepository {
  final Map<String, Map<String, dynamic>> _users = {};
  final List<Map<String, dynamic>> _sessions = [];
  final Map<String, Map<String, dynamic>> _checkpoints = {};

  @override
  Future<Map<String, dynamic>?> getUserData(String userId) async =>
      _users[userId];

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    _users[userId] = {...?_users[userId], ...data};
  }

  @override
  Future<void> saveFocusSession(
    String userId,
    Map<String, dynamic> session,
  ) async {
    _sessions.add({'user_id': userId, ...session});
  }

  @override
  Future<void> saveCheckpoint(String userId, Map<String, dynamic> data) async {
    _checkpoints[userId] = data;
  }

  @override
  Future<Map<String, dynamic>?> getLatestCheckpoint(String userId) async =>
      _checkpoints[userId];

  // Test helpers
  List<Map<String, dynamic>> get sessions => List.unmodifiable(_sessions);

  void clear() {
    _users.clear();
    _sessions.clear();
    _checkpoints.clear();
  }
}
