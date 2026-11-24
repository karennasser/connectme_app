import '../../domain/entities/user.dart';
import '../../patterns/user_builder.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final built = UserBuilder()
        .id(json['id'] as String)
        .fullName((json['fullName'] ?? '') as String)
        .email((json['email'] ?? '') as String)
        .photoUrl(json['photoUrl'] as String?)
        .build();
    return UserModel(
      id: built.id,
      fullName: built.fullName,
      email: built.email,
      photoUrl: built.photoUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'photoUrl': photoUrl,
      };

  factory UserModel.fromEntity(AppUser user) => UserModel(
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        photoUrl: user.photoUrl,
      );
}
