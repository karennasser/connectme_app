import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.photoUrl,
  });

  final String id;
  final String fullName;
  final String email;
  final String? photoUrl;

  @override
  List<Object?> get props => [id, fullName, email, photoUrl];
}
