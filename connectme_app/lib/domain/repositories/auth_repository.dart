import '../entities/user.dart';

abstract class AuthRepository {
  AppUser? get currentUser;
  Future<AppUser> login(String email, String password);
  Future<AppUser> signUp(String fullName, String email, String password);
  Future<void> logout();
  Stream<AppUser?> authChanges();
}
