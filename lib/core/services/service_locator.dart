import 'package:doctorbooking/features/home/presentation/cubit/appointment_cubit/appointments_cubit.dart';
import 'package:doctorbooking/features/home/presentation/cubit/my_appointments_cubit/my_appointments_cubit.dart';
import 'package:get_it/get_it.dart';
import '../../features/home/data/datasources/appointments_datasources.dart';
import '../../features/home/data/repositories/appointments_repositories.dart';
import '../../features/home/presentation/cubit/home_cubit/home_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
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
}
