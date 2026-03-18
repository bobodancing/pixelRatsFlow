/// Abstract auth interface. MVP: Google Sign-in only.
/// Phase 2: Solana wallet via Cloud Function + signInWithCustomToken.
abstract class AuthRepository {
  Future<AuthUser?> signInWithGoogle();
  Future<void> signOut();
  Stream<AuthUser?> authStateChanges();

  /// Phase 2: Link additional auth providers (Solana wallet).
  Future<void> linkProvider(dynamic credential);
}

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
