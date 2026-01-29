import 'package:get_it/get_it.dart';
import '../../features/shared/doctors/data/datasources/doctors_datasource.dart';
import '../../features/shared/doctors/data/repositories/doctors_repository.dart';
import '../../features/shared/doctors/presentation/cubit/doctors_cubit.dart';
import '../../features/appointments/data/datasources/appointment_datasource.dart';
import '../../features/appointments/data/repositories/appointment_repository.dart';
import '../../features/appointments/presentation/my_appointments/cubit/my_appointments_cubit.dart';
import '../../features/appointments/presentation/appointment_details/cubit/appointment_details_cubit.dart';
import '../../features/appointments/presentation/book_appointment/cubit/book_appointment_cubit.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit/home_cubit.dart';

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

  // =====================================================
  // التقييمات (Reviews)
  // =====================================================

  // Cubit
}
