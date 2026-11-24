import '../../services/auth_service.dart';
import '../../patterns/user_builder.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this.service);
  final AuthService service;

  UserModel _mapUser(dynamic user, {String? name}) {
    return UserModel(
      id: user.uid as String,
      fullName: name ?? user.displayName as String? ?? 'ConnectMe Member',
      email: user.email as String? ?? '',
      photoUrl: user.photoURL as String?,
    );
  }

  Future<UserModel> login(String email, String password) async {
    final result = await service.login(email, password);
    return _mapUser(result.user);
  }

  Future<UserModel> signUp(String name, String email, String password) async {
    final result = await service.signUp(email, password);
    await result.user?.updateDisplayName(name);
    return _mapUser(result.user, name: name);
  }

  UserModel? get currentUser {
    final user = service.currentUser;
    return user == null ? null : _mapUser(user);
  }

  Stream<UserModel?> authChanges() => service.authChanges.map(
        (user) => user == null ? null : _mapUser(user),
      );

  Future<void> logout() => service.logout();
}
