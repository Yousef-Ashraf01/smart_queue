import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_queue/core/networking/dio_client.dart';
import 'package:smart_queue/core/storage/secure_storage_service.dart';
import 'package:smart_queue/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smart_queue/features/auth/data/repositories/auth_repository.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/branch_booking/data/datasources/booking_remote_data_source.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/services_cubit.dart';
import 'package:smart_queue/features/home/data/datasources/organization_remote_data_source.dart';
import 'package:smart_queue/features/home/data/repositories/organization_repository.dart';
import 'package:smart_queue/features/home/presentation/cubit/organization_cubit.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/operations_cubit.dart';
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

  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepository(sl<BookingRemoteDataSource>()),
  );

  sl.registerFactory<BookingCubit>(() => BookingCubit(sl<BookingRepository>()));
  sl.registerFactory<OperationsCubit>(
    () => OperationsCubit(sl<BookingRepository>()),
  );
  sl.registerFactory<ServicesCubit>(
    () => ServicesCubit(sl<BookingRepository>()),
  );

  sl.registerFactory<OrganizationsCubit>(
    () => OrganizationsCubit(sl<OrganizationRepository>()),
  );

  sl.registerLazySingleton<OrganizationRemoteDataSource>(
    () => OrganizationRemoteDataSource(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<OrganizationRepository>(
    () => OrganizationRepository(sl<OrganizationRemoteDataSource>()),
  );
}
