import 'package:get_it/get_it.dart';
import '../../features/home/data/datasources/appointments_datasources.dart';
import '../../features/home/data/repositories/appointments_repositories.dart';
import '../../features/home/presentation/cubit/appointment_cubit/appointments_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit/home_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // =====================================================
  // المواعيد (Appointments)
  // =====================================================

  // Cubit
  sl.registerFactory(() => AppointmentsCubit(repository: sl()));

  // Home Cubit
  sl.registerFactory(() => HomeCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepository(datasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<AppointmentsDatasource>(
    () => AppointmentsDatasourceImpl(),
  );
}
