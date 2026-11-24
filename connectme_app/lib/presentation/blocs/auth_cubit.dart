import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState {
  const AuthState(this.status, {this.user, this.message});
  final AuthStatus status;
  final AppUser? user;
  final String? message;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.repository) : super(const AuthState(AuthStatus.initial));
  final AuthRepository repository;

  void checkAuth() {
    final user = repository.currentUser;
    emit(AuthState(user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated,
        user: user));
    repository.authChanges().listen((user) {
      emit(AuthState(user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated,
          user: user));
    });
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState(AuthStatus.loading));
    try {
      final user = await repository.login(email.trim(), password);
      emit(AuthState(AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(AuthState(AuthStatus.failure, message: e.toString()));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(const AuthState(AuthStatus.loading));
    try {
      final user = await repository.signUp(name.trim(), email.trim(), password);
      emit(AuthState(AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(AuthState(AuthStatus.failure, message: e.toString()));
    }
  }

  Future<void> logout() async {
    await repository.logout();
    emit(const AuthState(AuthStatus.unauthenticated));
  }
}
