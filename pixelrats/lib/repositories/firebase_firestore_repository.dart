import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_repository.dart';

class FirebaseFirestoreRepository implements FirestoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.data();
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await _db
        .collection('users')
        .doc(userId)
        .set(data, SetOptions(merge: true));
  }

  @override
  Future<void> saveFocusSession(
    String userId,
    Map<String, dynamic> session,
  ) async {
    await _db.collection('focus_sessions').add({
      'user_id': userId,
      'created_at': FieldValue.serverTimestamp(),
      ...session,
    });
  }

  @override
  Future<void> saveCheckpoint(String userId, Map<String, dynamic> data) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('checkpoints')
        .doc('latest')
        .set({'updated_at': FieldValue.serverTimestamp(), ...data});
  }

  @override
  Future<Map<String, dynamic>?> getLatestCheckpoint(String userId) async {
    final doc = await _db
        .collection('users')
        .doc(userId)
        .collection('checkpoints')
        .doc('latest')
        .get();
    return doc.data();
  }
}
