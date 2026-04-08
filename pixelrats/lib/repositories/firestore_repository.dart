/// Abstract Firestore interface for data persistence.
///
/// Sprint 1 uses Map[String, dynamic] for flexibility.
/// Sprint 3 will expand to typed interface per CLAUDE.md Section 4.3
/// (getRat, updateMood, getInventory, etc.) when freezed models exist.
abstract class FirestoreRepository {
  Future<Map<String, dynamic>?> getUserData(String userId);
  Future<void> updateUserData(String userId, Map<String, dynamic> data);
  Future<void> saveFocusSession(String userId, Map<String, dynamic> session);
  Future<void> saveCheckpoint(String userId, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getLatestCheckpoint(String userId);
}
