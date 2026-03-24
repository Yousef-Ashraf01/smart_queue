import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_queue/core/networking/dio_client.dart';
import 'package:smart_queue/core/storage/secure_storage_service.dart';
import 'package:smart_queue/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smart_queue/features/auth/data/repositories/auth_repository.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/personal_info/data/datasources/personal_info_remote_data_source.dart';
import 'package:smart_queue/features/personal_info/data/repositories/personal_info_repository.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl<Dio>(), sl<SecureStorageService>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<DioClient>().dio, sl<SecureStorageService>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<AuthRemoteDataSource>()),
  );

  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepository>()));

  sl.registerLazySingleton<PersonalInfoRemoteDataSource>(
    () => PersonalInfoRemoteDataSource(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<PersonalInfoRepository>(
    () => PersonalInfoRepository(sl<PersonalInfoRemoteDataSource>()),
  );

  sl.registerFactory<PersonalInfoCubit>(
    () => PersonalInfoCubit(sl<PersonalInfoRepository>()),
  );
}
