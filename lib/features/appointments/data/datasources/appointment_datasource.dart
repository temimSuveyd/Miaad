import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/supabase_helper.dart';
import '../models/appointment.dart';

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
}

class SharedAppointmentsDatasourceImpl implements SharedAppointmentDatasource {
  final SupabaseClient client = SupabaseHelper.client;

  static const String tableName = 'appointments';
  static const String viewTable = 'appointment_view';

  @override
  Future<AppointmentModel> createAppointment(
    AppointmentModel appointment,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(tableName)
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
          .from(viewTable)
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
          .from(viewTable)
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
          table: tableName,
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
          .from(viewTable)
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
          .from(viewTable)
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
          .from(tableName)
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
      await client.from(tableName).delete().eq('id', id);
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
          .from(tableName)
          .update({
            'status': 'cancelled',
            'cancelled_by': cancelledBy,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      // جلب البيانات المحدثة من الـ VIEW
      final response = await client
          .from(viewTable)
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
      await client
          .from(tableName)
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
          .from(viewTable)
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
          .from(viewTable)
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
          .from(viewTable)
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
          .from(viewTable)
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
}
