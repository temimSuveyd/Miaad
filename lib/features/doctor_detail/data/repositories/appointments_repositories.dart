import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/appointments_datasources.dart';
import '../models/appointments_model.dart';

// مستودع المواعيد - إدارة العمليات مع معالجة الأخطاء
class AppointmentsRepository {
  final AppointmentsDatasource datasource;

  AppointmentsRepository({required this.datasource});

  // إنشاء موعد جديد
  Future<Either<Failure, AppointmentsModel>> createAppointment(
    AppointmentsModel appointment,
  ) async {
    try {
      final result = await datasource.createAppointment(appointment);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على موعد بواسطة المعرف
  Future<Either<Failure, AppointmentsModel>> getAppointmentById(
    String id,
  ) async {
    try {
      final result = await datasource.getAppointmentById(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على مواعيد المستخدم
  Future<Either<Failure, List<AppointmentsModel>>> getUserAppointments(
    String userId,
  ) async {
    try {
      final result = await datasource.getUserAppointments(userId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // الحصول على مواعيد الطبيب
  Future<Either<Failure, List<AppointmentsModel>>> getDoctorAppointments(
    String doctorId,
  ) async {
    try {
      final result = await datasource.getDoctorAppointments(doctorId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // تحديث موعد
  Future<Either<Failure, AppointmentsModel>> updateAppointment(
    AppointmentsModel appointment,
  ) async {
    try {
      final result = await datasource.updateAppointment(appointment);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // حذف موعد
  Future<Either<Failure, void>> deleteAppointment(String id) async {
    try {
      await datasource.deleteAppointment(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // إلغاء موعد
  Future<Either<Failure, AppointmentsModel>> cancelAppointment(
    String id,
    String cancelledBy,
  ) async {
    try {
      final result = await datasource.cancelAppointment(id, cancelledBy);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }

  // إعادة جدولة موعد
  Future<Either<Failure, AppointmentsModel>> rescheduleAppointment(
    String id,
    DateTime newDate,
    String newTime,
    String rescheduledBy,
  ) async {
    try {
      final result = await datasource.rescheduleAppointment(
        id,
        newDate,
        newTime,
        rescheduledBy,
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('خطأ غير متوقع: $e'));
    }
  }


}
