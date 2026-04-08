import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract auth interface. MVP: Google Sign-in only.
/// Phase 2: Solana wallet via Cloud Function + signInWithCustomToken.
abstract class AuthRepository {
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  Stream<AuthUser?> authStateChanges();

  /// Phase 2: Link additional auth providers (Solana wallet).
  Future<void> linkProvider(dynamic credential);
}

/// Provider for the auth repository — overridden in main.dart with
/// the Firebase implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('authRepositoryProvider must be overridden');
});

/// Minimal auth user representation (decoupled from Firebase).
class AuthUser {
  const AuthUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
}
