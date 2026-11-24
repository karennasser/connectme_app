import '../domain/entities/user.dart';

/// Builder Pattern: optional profile values are added only when supplied.
class UserBuilder {
  String? _id;
  String? _fullName;
  String? _email;
  String? _photoUrl;

  UserBuilder id(String value) { _id = value; return this; }
  UserBuilder fullName(String value) { _fullName = value; return this; }
  UserBuilder email(String value) { _email = value; return this; }
  UserBuilder photoUrl(String? value) { _photoUrl = value; return this; }

  AppUser build() {
    if (_id == null || _fullName == null || _email == null) {
      throw StateError('User id, full name and email are required.');
    }
    return AppUser(
      id: _id!,
      fullName: _fullName!,
      email: _email!,
      photoUrl: _photoUrl,
    );
  }
}
