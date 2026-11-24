import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/firestore_post_datasource.dart';
import 'data/datasources/local_post_datasource.dart';
import 'data/datasources/profile_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/post_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecases/create_post.dart';
import 'domain/usecases/get_posts.dart';
import 'patterns/post_datasource_factory.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/post_cubit.dart';
import 'presentation/blocs/profile_cubit.dart';
import 'services/auth_service.dart';
import 'services/biometric_service.dart';
import 'services/device_info_service.dart';
import 'services/firestore_service.dart';
import 'services/image_picker_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Singleton: a single FirestoreService is shared throughout the app.
  getIt.registerLazySingleton(() => FirestoreService(FirebaseFirestore.instance));
  getIt.registerLazySingleton(() => AuthService(firebase.FirebaseAuth.instance));
  getIt.registerLazySingleton(() => BiometricService());
  getIt.registerLazySingleton(() => DeviceInfoService());
  getIt.registerLazySingleton(() => ImagePickerService());

  getIt.registerLazySingleton(() => AuthRemoteDataSource(getIt<AuthService>()));
  getIt.registerLazySingleton(() => ProfileRemoteDataSource(
        getIt<FirestoreService>(),
        FirebaseStorage.instance,
      ));

  getIt.registerLazySingleton(() => FirestorePostDataSource(getIt<FirestoreService>()));
  getIt.registerLazySingleton(() => LocalPostDataSource());

  // Factory: choose the source based on the requested storage strategy.
  getIt.registerFactory<PostRepository>(() => PostRepositoryImpl(
        PostDataSourceFactory.create(
          useLocal: false,
          remote: getIt<FirestorePostDataSource>(),
          local: getIt<LocalPostDataSource>(),
        ),
      ));

  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()));
  getIt.registerLazySingleton<ProfileRepository>(() =>
      ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()));

  getIt.registerLazySingleton(() => GetPosts(getIt<PostRepository>()));
  getIt.registerLazySingleton(() => CreatePost(getIt<PostRepository>()));

  getIt.registerFactory(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory(() => PostCubit(getIt<GetPosts>(), getIt<CreatePost>()));
  getIt.registerFactory(() => ProfileCubit(
        getIt<ProfileRepository>(),
        getIt<DeviceInfoService>(),
        getIt<ImagePickerService>(),
      ));
}
