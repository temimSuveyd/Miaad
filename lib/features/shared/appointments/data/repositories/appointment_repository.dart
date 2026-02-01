import 'package:dartz/dartz.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../datasources/appointment_datasource.dart';
import '../models/appointment.dart';
import '../models/slot_model.dart';
import '../models/doctor_schedule_model.dart';

/// مستودع المواعيد المشترك - إدارة العمليات مع معالجة الأخطاء
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

  // ========== Slot System Methods ==========

  /// الحصول على السلوتس المتاحة لطبيب معين
  Future<Either<Failure, List<SlotModel>>> getAvailableSlots(
    String doctorId, {
    int daysAhead = 15,
  }) async {
    try {
      final result = await datasource.getAvailableSlots(doctorId, daysAhead: daysAhead);
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

  /// حجز سلوت
  Future<Either<Failure, bool>> bookSlot(
    String slotId,
    String userId,
    String appointmentId,
  ) async {
    try {
      final result = await datasource.bookSlot(slotId, userId, appointmentId);
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

  /// إلغاء/تحرير سلوت
  Future<Either<Failure, bool>> freeSlot(
    String appointmentId, {
    SlotStatus newStatus = SlotStatus.available,
  }) async {
    try {
      final result = await datasource.freeSlot(appointmentId, newStatus: newStatus);
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

  /// الحصول على سلوت بواسطة المعرف
  Future<Either<Failure, SlotModel>> getSlotById(String slotId) async {
    try {
      final result = await datasource.getSlotById(slotId);
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

  /// الحصول على سلوتس بواسطة موعد
  Future<Either<Failure, SlotModel?>> getSlotByAppointmentId(String appointmentId) async {
    try {
      final result = await datasource.getSlotByAppointmentId(appointmentId);
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

  /// تحديث حالة السلوت
  Future<Either<Failure, SlotModel>> updateSlotStatus(
    String slotId,
    SlotStatus status, {
    String? appointmentId,
    String? bookedBy,
  }) async {
    try {
      final result = await datasource.updateSlotStatus(
        slotId,
        status,
        appointmentId: appointmentId,
        bookedBy: bookedBy,
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

  /// حجز موعد باستخدام السلوت
  Future<Either<Failure, AppointmentModel>> createAppointmentWithSlot(
    AppointmentModel appointment,
    String slotId,
  ) async {
    try {
      // أولاً إنشاء الموعد للحصول على معرف من قاعدة البيانات
      final createdAppointment = await datasource.createAppointment(appointment);

      // ثم حجز السلوت باستخدام معرف الموعد الذي تم إنشاؤه
      final bookResult = await datasource.bookSlot(
        slotId,
        createdAppointment.userId,
        createdAppointment.id!,
      );

      if (!bookResult) {
        return const Left(ServerFailure('فشل حجز السلوت'));
      }
      return Right(createdAppointment);
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

  /// الحصول على جدول عمل الطبيب
  Future<List<DoctorScheduleModel>> getDoctorSchedules(String doctorId) async {
    try {
      return await datasource.getDoctorSchedules(doctorId);
    } catch (e) {
      throw Exception('فشل في تحميل جدول العمل: $e');
    }
  }
}
