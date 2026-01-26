import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:doctorbooking/features/home/presentation/cubit/my_appointments_cubit/my_appointments_cubit.dart';
import 'package:doctorbooking/features/home/presentation/cubit/reviews_cubit/reviews_cubit.dart';
import 'package:doctorbooking/features/search/presentation/cubit/search_cubit.dart';
import 'package:get_it/get_it.dart';
import '../../features/home/data/datasources/appointments_datasources.dart';
import '../../features/home/data/datasources/reviews_datasource.dart';
import '../../features/home/data/datasources/doctors_datasource.dart';
import '../../features/home/data/repositories/appointments_repositories.dart';
import '../../features/home/data/repositories/reviews_repository.dart';
import '../../features/home/data/repositories/doctors_repository.dart';
import '../../features/home/presentation/cubit/home_cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/doctors_cubit/doctors_cubit.dart';
import '../../features/search/data/datasources/search_datasource.dart';
import '../../features/search/data/repositories/search_repository.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // =====================================================
  // الأطباء (Doctors)
  // =====================================================

  // Cubit
  sl.registerFactory(() => DoctorsCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<DoctorsRepository>(
    () => DoctorsRepository(datasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<DoctorsDatasource>(() => DoctorsDatasourceImpl());

  // =====================================================
  // البحث (Search)
  // =====================================================

  // Search Cubit
  sl.registerFactory(() => SearchCubit(repository: sl()));

  // Search Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepository(datasource: sl()),
  );

  // Search Datasource
  sl.registerLazySingleton<SearchDatasource>(() => SearchDatasourceImpl());

  // =====================================================
  // المواعيد (Appointments)
  // =====================================================

  // Cubit
  sl.registerFactory(() => BookAppointmentCubit(repository: sl()));

  // Home Cubit
  sl.registerFactory(() => HomeCubit(repository: sl()));

  // My Appointments Cubit
  sl.registerFactory(() => MyAppointmentsCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepository(datasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<AppointmentsDatasource>(
    () => AppointmentsDatasourceImpl(),
  );

  // =====================================================
  // التقييمات (Reviews)
  // =====================================================

  // Cubit
  sl.registerFactory(() => ReviewsCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepository(datasource: sl(), appointmentsRepository: sl()),
  );

  // Datasource
  sl.registerLazySingleton<ReviewsDatasource>(() => ReviewsDatasourceImpl());
}
