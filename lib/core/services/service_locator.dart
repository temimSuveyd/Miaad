import 'package:get_it/get_it.dart';
import '../../features/shared/doctors/data/datasources/doctors_datasource.dart';
import '../../features/shared/doctors/data/repositories/doctors_repository.dart';
import '../../features/shared/doctors/presentation/cubit/doctors_cubit.dart';
import '../../features/shared/appointments/data/datasources/appointment_datasource.dart';
import '../../features/shared/appointments/data/repositories/appointment_repository.dart';
import '../../features/shared/appointments/presentation/my_appointments/cubit/my_appointments_cubit.dart';
import '../../features/shared/appointments/presentation/appointment_details/cubit/appointment_details_cubit.dart';
import '../../features/shared/appointments/presentation/book_appointment/cubit/book_appointment_cubit.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/doctor_details_cubit/doctor_details_cubit.dart';
import '../../features/reviews/presentation/cubit/reviews_cubit.dart';
import '../../features/reviews/data/repositories/reviews_repository.dart';
import '../../features/reviews/data/datasources/reviews_datasource.dart';
import '../../features/shared/specialities/data/datasources/specialities_datasource.dart';
import '../../features/shared/specialities/data/repositories/specialities_repository.dart';
import '../../features/shared/specialities/presentation/cubit/specialities_cubit.dart';
import '../../features/auth/data/datasources/auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/profile/presentation/cubit/settings_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/data/repositories/settings_repository.dart';
import '../../features/profile/data/datasources/settings_datasource.dart';
import '../../core/config/supabase_config.dart';
import '../../core/services/secure_storage_service.dart';
import '../../core/services/notification_service.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // =====================================================
  // الأطباء المشتركة (Shared Doctors)
  // =====================================================

  // Shared Doctors Cubit
  sl.registerFactory(
    () => SharedDoctorsCubit(repository: sl<SharedDoctorsRepository>()),
  );

  // Shared Doctors Repository
  sl.registerLazySingleton<SharedDoctorsRepository>(
    () => SharedDoctorsRepository(datasource: sl()),
  );

  // Shared Doctors Datasource
  sl.registerLazySingleton<SharedDoctorsDatasource>(
    () => SharedDoctorsDatasourceImpl(),
  );

  // =====================================================
  // البحث (Search)
  // =====================================================

  // Search Cubit
  sl.registerFactory(
    () => SearchCubit(repository: sl<SharedDoctorsRepository>()),
  );

  // =====================================================
  // المواعيد المشتركة (Shared Appointments)
  // =====================================================

  // My Appointments Cubit
  sl.registerFactory(
    () => MyAppointmentsCubit(repository: sl<SharedAppointmentRepository>()),
  );

  // Appointment Details Cubit
  sl.registerFactory(
    () =>
        AppointmentDetailsCubit(repository: sl<SharedAppointmentRepository>()),
  );

  // Book Appointment Cubit
  sl.registerFactory(
    () => BookAppointmentCubit(repository: sl<SharedAppointmentRepository>()),
  );

  // Shared Appointments Repository
  sl.registerLazySingleton<SharedAppointmentRepository>(
    () => SharedAppointmentRepository(datasource: sl()),
  );

  // Shared Appointments Datasource
  sl.registerLazySingleton<SharedAppointmentDatasource>(
    () => SharedAppointmentsDatasourceImpl(),
  );

  // =====================================================
  // الصفحة الرئيسية (Home)
  // =====================================================

  // Home Cubit
  sl.registerFactory(
    () => HomeCubit(repository: sl<SharedAppointmentRepository>()),
  );

  // Doctor Details Cubit
  sl.registerFactory(
    () => DoctorDetailCubit(repository: sl<SharedAppointmentRepository>()),
  );

  // =====================================================
  // التخصصات (Shared Specialities)
  // =====================================================

  sl.registerFactory(
    () => SharedSpecialitiesCubit(repository: sl<SharedSpecialitiesRepository>()),
  );

  sl.registerLazySingleton<SharedSpecialitiesRepository>(
    () => SharedSpecialitiesRepository(datasource: sl()),
  );

  sl.registerLazySingleton<SharedSpecialitiesDatasource>(
    () => SharedSpecialitiesDatasourceImpl(),
  );

  // =====================================================
  // التقييمات (Reviews)
  // =====================================================

  // Reviews Cubit
  sl.registerFactory(
    () => ReviewsCubit(repository: sl<ReviewsRepository>()),
  );

  // Reviews Repository
  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepository(
      datasource: sl(),
      appointmentsRepository: sl<SharedAppointmentRepository>(),
    ),
  );

  // Reviews Datasource
  sl.registerLazySingleton<ReviewsDatasource>(
    () => ReviewsDatasourceImpl(),
  );

  // =====================================================
  // المصادقة (Authentication)
  // =====================================================

  // Auth Cubit
  sl.registerFactory(
    () => AuthCubit(sl<AuthRepository>()),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Auth Datasource
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(SupabaseConfig.client),
  );

  // =====================================================
  // الإعدادات (Settings)
  // =====================================================

  // Settings Cubit
  sl.registerFactory(
    () => SettingsCubit(),
  );

  // Settings Datasource
  sl.registerLazySingleton<SettingsDataSource>(
    () => SettingsDataSourceImpl(),
  );

  // Settings Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(dataSource: sl()),
  );

  // Profile Cubit
  sl.registerFactory(
    () => ProfileCubit(repository: sl<SettingsRepository>()),
  );

  // Notification Service
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
}
