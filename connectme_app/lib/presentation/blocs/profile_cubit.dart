import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../services/device_info_service.dart';
import '../../services/image_picker_service.dart';

class ProfileState {
  const ProfileState({this.user, this.deviceInfo = '', this.loading = false, this.message});
  final AppUser? user;
  final String deviceInfo;
  final bool loading;
  final String? message;
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.repository, this.deviceService, this.imagePicker)
      : super(const ProfileState());
  final ProfileRepository repository;
  final DeviceInfoService deviceService;
  final ImagePickerService imagePicker;

  Future<void> loadProfile(String uid) async {
    emit(ProfileState(user: state.user, loading: true));
    try {
      final results = await Future.wait([
        repository.getProfile(uid),
        deviceService.readDeviceInfo(),
      ]);
      emit(ProfileState(user: results[0] as AppUser, deviceInfo: results[1] as String));
    } catch (_) {
      emit(const ProfileState(message: 'Could not load profile information.'));
    }
  }

  Future<void> changePhoto(String uid) async {
    try {
      final file = await imagePicker.pickFromGallery();
      if (file == null) return;
      emit(ProfileState(user: state.user, deviceInfo: state.deviceInfo, loading: true));
      final url = await repository.uploadProfilePhoto(uid, file.path);
      final old = state.user;
      if (old != null) {
        emit(ProfileState(
          user: AppUser(id: old.id, fullName: old.fullName, email: old.email, photoUrl: url),
          deviceInfo: state.deviceInfo,
        ));
      }
    } catch (_) {
      emit(ProfileState(
        user: state.user,
        deviceInfo: state.deviceInfo,
        message: 'Could not update your profile photo.',
      ));
    }
  }
}
