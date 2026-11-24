import 'package:firebase_auth/firebase_auth.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.dataSource);
  final AuthRemoteDataSource dataSource;

  @override
  AppUser? get currentUser => dataSource.currentUser;

  @override
  Stream<AppUser?> authChanges() => dataSource.authChanges();

  @override
  Future<AppUser> login(String email, String password) async {
    try {
      return await dataSource.login(email, password);
    } on FirebaseAuthException catch (e) {
      throw AppFailure(_friendlyMessage(e));
    } catch (_) {
      throw const AppFailure('Unable to sign in. Please try again.');
    }
  }

  @override
  Future<AppUser> signUp(String name, String email, String password) async {
    try {
      return await dataSource.signUp(name, email, password);
    } on FirebaseAuthException catch (e) {
      throw AppFailure(_friendlyMessage(e));
    } catch (_) {
      throw const AppFailure('Unable to create your account. Please try again.');
    }
  }

  String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  @override
  Future<void> logout() => dataSource.logout();
}
