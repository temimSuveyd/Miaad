import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/appointment_datasource.dart';
import '../models/appointment.dart';

/// مستودع المواعيد المشترك - إدارة العمليات مع معالجة الأخطاء
/// Shared Appointments Repository - Manages operations with error handling
class SharedAppointmentRepository {
  final SharedAppointmentDatasource datasource;

  SharedAppointmentRepository({required this.datasource});

  /// إنشاء موعد جديد
  Future<Either<Failure, AppointmentModel>> createAppointment(
    AppointmentModel appointment,
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

  /// الحصول على موعد بواسطة المعرف
  Future<Either<Failure, AppointmentModel>> getAppointmentById(
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

  /// الحصول على مواعيد المستخدم
  Future<Either<Failure, List<AppointmentModel>>> getUserAppointments(
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

  /// الحصول على مواعيد المستخدم بشكل real-time
  Stream<Either<Failure, List<AppointmentModel>>> getUserAppointmentsStream(
    String userId,
  ) {
    try {
      return datasource
          .getUserAppointmentsStream(userId)
          .map(
            (appointments) =>
                Right<Failure, List<AppointmentModel>>(appointments),
          )
          .handleError((error) {
            return Left<Failure, List<AppointmentModel>>(
              ServerFailure('خطأ في الاتصال: $error'),
            );
          });
    } catch (e) {
      return Stream.value(
        Left<Failure, List<AppointmentModel>>(
          ServerFailure('خطأ في الاتصال: $e'),
        ),
      );
    }
  }

  /// الحصول على مواعيد الطبيب
  Future<Either<Failure, List<AppointmentModel>>> getDoctorAppointments(
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

  /// تحديث موعد
  Future<Either<Failure, AppointmentModel>> updateAppointment(
    AppointmentModel appointment,
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

  /// حذف موعد
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

  /// إلغاء موعد
  Future<Either<Failure, AppointmentModel>> cancelAppointment(
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

  /// إعادة جدولة موعد
  Future<Either<Failure, AppointmentModel>> rescheduleAppointment(
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

  /// الحصول على المواعيد القادمة للمستخدم
  Future<Either<Failure, List<AppointmentModel>>> getUpcomingAppointments(
    String userId,
  ) async {
    try {
      final result = await datasource.getUpcomingAppointments(userId);
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

  /// الحصول على المواعيد المكتملة للمستخدم
  Future<Either<Failure, List<AppointmentModel>>> getCompletedAppointments(
    String userId,
  ) async {
    try {
      final result = await datasource.getCompletedAppointments(userId);
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

  /// الحصول على المواعيد الملغية للمستخدم
  Future<Either<Failure, List<AppointmentModel>>> getCancelledAppointments(
    String userId,
  ) async {
    try {
      final result = await datasource.getCancelledAppointments(userId);
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
