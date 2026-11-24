import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this.dataSource);
  final ProfileRemoteDataSource dataSource;

  @override
  Future<AppUser> getProfile(String uid) => dataSource.getProfile(uid);

  @override
  Future<String> uploadProfilePhoto(String uid, String filePath) =>
      dataSource.uploadPhoto(uid, filePath);
}
