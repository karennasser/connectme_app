import '../entities/user.dart';

abstract class ProfileRepository {
  Future<AppUser> getProfile(String uid);
  Future<String> uploadProfilePhoto(String uid, String filePath);
}
