import 'package:get_it/get_it.dart';
import '../../features/doctor_detail/data/datasources/appointments_datasources.dart';
import '../../features/doctor_detail/data/repositories/appointments_repositories.dart';
import '../../features/doctor_detail/presentation/cubit/appointments_cubit.dart';

// موقع الخدمات - إدارة التبعيات
final sl = GetIt.instance;

// تهيئة جميع التبعيات
Future<void> initServiceLocator() async {
  // =====================================================
  // المواعيد (Appointments)
  // =====================================================

  // Cubit
  sl.registerFactory(() => AppointmentsCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepository(datasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<AppointmentsDatasource>(
    () => AppointmentsDatasourceImpl(),
  );
}
