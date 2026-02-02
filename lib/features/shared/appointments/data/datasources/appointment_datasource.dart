import 'dart:async';
import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/error/exceptions.dart' show DatabaseException;
import '../../../../../core/utils/supabase_helper.dart';
import '../models/appointment.dart';
import '../models/slot_model.dart';
import '../models/doctor_schedule_model.dart';

/// مصدر بيانات المواعيد المشترك
/// Shared Appointments Datasource
abstract class SharedAppointmentDatasource {
  /// إنشاء موعد جديد
  Future<AppointmentModel> createAppointment(AppointmentModel appointment);

  /// الحصول على موعد بواسطة المعرف
  Future<AppointmentModel> getAppointmentById(String id);

  /// الحصول على مواعيد المستخدم
  Future<List<AppointmentModel>> getUserAppointments(String userId);

  /// الحصول على مواعيد المستخدم بشكل real-time
  Stream<List<AppointmentModel>> getUserAppointmentsStream(String userId);

  /// الحصول على مواعيد الطبيب
  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId);

  /// تحديث موعد
  Future<AppointmentModel> updateAppointment(AppointmentModel appointment);

  /// حذف موعد
  Future<void> deleteAppointment(String id);

  /// إلغاء موعد
  Future<AppointmentModel> cancelAppointment(String id, String cancelledBy);

  /// إعادة جدولة موعد
  Future<AppointmentModel> rescheduleAppointment(
    String id,
    DateTime newDate,
    String newTime,
    String rescheduledBy,
  );

  /// الحصول على المواعيد القادمة للمستخدم
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId);

  /// الحصول على المواعيد المكتملة للمستخدم
  Future<List<AppointmentModel>> getCompletedAppointments(String userId);

  /// الحصول على المواعيد الملغية للمستخدم
  Future<List<AppointmentModel>> getCancelledAppointments(String userId);

  // ========== Slot System Methods ==========
  /// الحصول على السلوتس المتاحة لطبيب معين
  Future<List<SlotModel>> getAvailableSlots(
    String doctorId, {
    int daysAhead = 15,
  });

  /// حجز سلوت
  Future<bool> bookSlot(String slotId, String userId, String appointmentId);

  /// إلغاء/تحرير سلوت
  Future<bool> freeSlot(
    String appointmentId, {
    SlotStatus newStatus = SlotStatus.available,
  });

  /// الحصول على سلوت بواسطة المعرف
  Future<SlotModel> getSlotById(String slotId);

  /// الحصول على سلوتس بواسطة موعد
  Future<SlotModel?> getSlotByAppointmentId(String appointmentId);

  /// تحديث حالة السلوت
  Future<SlotModel> updateSlotStatus(
    String slotId,
    SlotStatus status, {
    String? appointmentId,
    String? bookedBy,
  });

  /// الحصول على جدول عمل الطبيب
  Future<List<DoctorScheduleModel>> getDoctorSchedules(String doctorId);
}

class SharedAppointmentsDatasourceImpl implements SharedAppointmentDatasource {
  final SupabaseClient client = SupabaseHelper.client;

  static const String appointmentsTable = 'appointments';
  static const String appointmentsView = 'appointment_view';
  static const String slotsTable = 'available_slots';
  static const String slotsView = 'get_available_slots';

  @override
  Future<AppointmentModel> createAppointment(
    AppointmentModel appointment,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      final existingActiveAppointments = await client
          .from(appointmentsTable)
          .select('id')
          .eq('user_id', appointment.userId)
          .eq('doctor_id', appointment.doctorId)
          .inFilter('status', ['upcoming', 'rescheduled'])
          .limit(2);

      if ((existingActiveAppointments as List).length >= 2) {
        throw const DatabaseException(
          'لا يمكنك حجز أكثر من موعدين نشطين مع نفس الطبيب',
        );
      }

      final response = await client
          .from(appointmentsTable)
          .insert(appointment.toJson())
          .select()
          .single();
      return AppointmentModel.fromJson(response);
    });
  }

  @override
  Future<AppointmentModel> getAppointmentById(String id) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(appointmentsView)
          .select()
          .eq('id', id)
          .single();

      return AppointmentModel.fromJson(response);
    });
  }

  @override
  Future<List<AppointmentModel>> getUserAppointments(String userId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(appointmentsView)
          .select()
          .eq('user_id', userId)
          .order('date', ascending: true)
          .order('time', ascending: true);

      return (response as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    });
  }

  @override
  Stream<List<AppointmentModel>> getUserAppointmentsStream(String userId) {
    final controller = StreamController<List<AppointmentModel>>.broadcast();

    // تحميل البيانات الأولية
    _loadInitialData(userId, controller);

    // إنشاء قناة للاستماع للتغييرات
    final channel = client
        .channel('appointments_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: appointmentsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            // إعادة تحميل البيانات عند حدوث تغيير
            _loadInitialData(userId, controller);
          },
        )
        .subscribe();

    // إلغاء الاشتراك عند إغلاق الـ stream
    controller.onCancel = () {
      client.removeChannel(channel);
    };

    return controller.stream;
  }

  Future<void> _loadInitialData(
    String userId,
    StreamController<List<AppointmentModel>> controller,
  ) async {
    try {
      final data = await client
          .from(appointmentsView)
          .select()
          .eq('user_id', userId)
          .order('date', ascending: true)
          .order('time', ascending: true);

      final appointments = (data as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();

      if (!controller.isClosed) {
        controller.add(appointments);
      }
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  @override
  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(appointmentsView)
          .select()
          .eq('doctor_id', doctorId)
          .order('date', ascending: true)
          .order('time', ascending: true);

      return (response as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<AppointmentModel> updateAppointment(
    AppointmentModel appointment,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(appointmentsTable)
          .update(appointment.toJson())
          .eq('id', appointment.id!)
          .select()
          .single();

      return AppointmentModel.fromJson(response);
    });
  }

  @override
  Future<void> deleteAppointment(String id) async {
    return await SupabaseHelper.executeQuery(() async {
      await client.from(appointmentsTable).delete().eq('id', id);
    });
  }

  @override
  Future<AppointmentModel> cancelAppointment(
    String id,
    String cancelledBy,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      // تحديث حالة الموعد إلى ملغي
      await client
          .from(appointmentsTable)
          .update({
            'status': 'cancelled',
            'cancelled_by': cancelledBy,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      // تحرير السلوت المرتبط بالموعد
      await freeSlot(id, newStatus: SlotStatus.available);

      // جلب البيانات المحدثة من الـ VIEW
      final response = await client
          .from(appointmentsView)
          .select()
          .eq('id', id)
          .single();

      return AppointmentModel.fromJson(response);
    });
  }

  @override
  Future<AppointmentModel> rescheduleAppointment(
    String id,
    DateTime newDate,
    String newTime,
    String rescheduledBy,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      // تحرير السلوت القديم
      await freeSlot(id, newStatus: SlotStatus.available);

      // تحديث الموعد بالبيانات الجديدة
      await client
          .from(appointmentsTable)
          .update({
            'date': newDate.toIso8601String().split('T')[0],
            'time': newTime,
            'status': 'rescheduled',
            'rescheduled_by': rescheduledBy,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      // جلب البيانات المحدثة من الـ VIEW
      final response = await client
          .from(appointmentsView)
          .select()
          .eq('id', id)
          .single();

      return AppointmentModel.fromJson(response);
    });
  }

  @override
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(appointmentsView)
          .select()
          .eq('user_id', userId)
          .inFilter('status', ['upcoming', 'rescheduled'])
          .order('date', ascending: true)
          .order('time', ascending: true);

      return (response as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<AppointmentModel>> getCompletedAppointments(String userId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(appointmentsView)
          .select()
          .eq('user_id', userId)
          .eq('status', 'completed')
          .order('date', ascending: false)
          .order('time', ascending: false);

      return (response as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<AppointmentModel>> getCancelledAppointments(String userId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(appointmentsView)
          .select()
          .eq('user_id', userId)
          .eq('status', 'cancelled')
          .order('date', ascending: false)
          .order('time', ascending: false);

      return (response as List)
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    });
  }

  // ========== Slot System Implementation ==========

  @override
  Future<List<SlotModel>> getAvailableSlots(
    String doctorId, {
    int daysAhead = 15,
  }) async {
    return await SupabaseHelper.executeQuery(() async {
      // استخدام الدالة المخصصة من PostgreSQL
      final response = await client.rpc(
        'get_available_slots',
        params: {'p_doctor_id': doctorId, 'p_days_ahead': daysAhead},
      );

      return (response as List).map((json) {
        final slot = SlotModel.fromJson(json);
        return slot;
      }).toList();
    });
  }

  @override
  Future<bool> bookSlot(
    String slotId,
    String userId,
    String appointmentId,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      // استخدام الدالة المخصصة من PostgreSQL
      final response = await client.rpc(
        'book_appointment',
        params: {
          'p_slot_id': slotId,
          'p_user_id': userId,
          'p_appointment_id': appointmentId,
        },
      );

      return response as bool? ?? false;
    });
  }

  @override
  Future<bool> freeSlot(
    String appointmentId, {
    SlotStatus newStatus = SlotStatus.available,
  }) async {
    return await SupabaseHelper.executeQuery(() async {
      // استخدام الدالة المخصصة من PostgreSQL
      final response = await client.rpc(
        'free_appointment_slot',
        params: {
          'p_appointment_id': appointmentId,
          'p_new_status': _slotStatusToString(newStatus),
        },
      );

      return response as bool? ?? false;
    });
  }

  @override
  Future<SlotModel> getSlotById(String slotId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(slotsTable)
          .select()
          .eq('id', slotId)
          .single();

      return SlotModel.fromJson(response);
    });
  }

  @override
  Future<SlotModel?> getSlotByAppointmentId(String appointmentId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(slotsTable)
          .select()
          .eq('appointment_id', appointmentId)
          .maybeSingle();

      if (response == null) return null;
      return SlotModel.fromJson(response);
    });
  }

  @override
  Future<SlotModel> updateSlotStatus(
    String slotId,
    SlotStatus status, {
    String? appointmentId,
    String? bookedBy,
  }) async {
    return await SupabaseHelper.executeQuery(() async {
      final updateData = {
        'status': _slotStatusToString(status),
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (appointmentId != null) {
        updateData['appointment_id'] = appointmentId;
      }
      if (bookedBy != null) {
        updateData['booked_by'] = bookedBy;
        updateData['booked_at'] = DateTime.now().toIso8601String();
      }

      final response = await client
          .from(slotsTable)
          .update(updateData)
          .eq('id', slotId)
          .select()
          .single();

      return SlotModel.fromJson(response);
    });
  }

  /// Helper method to convert SlotStatus enum to string
  String _slotStatusToString(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return 'available';
      case SlotStatus.booked:
        return 'booked';
      case SlotStatus.completed:
        return 'completed';
      case SlotStatus.cancelled:
        return 'cancelled';
    }
  }

  /// الحصول على جدول عمل الطبيب
  Future<List<DoctorScheduleModel>> getDoctorSchedules(String doctorId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from('doctor_schedules')
          .select('*')
          .eq('doctor_id', doctorId)
          .eq('is_active', true)
          .order('day_of_week', ascending: true);

      return (response as List)
          .map((json) => DoctorScheduleModel.fromJson(json))
          .toList();
    });
  }
}
