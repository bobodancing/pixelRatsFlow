import 'dart:async';
import '../auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<AuthUser?>.broadcast();
  AuthUser? _currentUser;

  @override
  Future<AuthUser?> signInWithGoogle() async {
    _currentUser = const AuthUser(
      uid: 'mock-user-001',
      displayName: 'Test User',
      email: 'test@pixelrats.com',
    );
    _controller.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  @override
  Stream<AuthUser?> authStateChanges() => _controller.stream;

  @override
  Future<void> linkProvider(dynamic credential) async {}

  void dispose() => _controller.close();
}
