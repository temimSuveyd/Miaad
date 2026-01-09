import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/supabase_helper.dart';
import '../models/appointments_model.dart';

// مصدر بيانات المواعيد
abstract class AppointmentsDatasource {
  // إنشاء موعد جديد
  Future<AppointmentsModel> createAppointment(AppointmentsModel appointment);

  // الحصول على موعد بواسطة المعرف
  Future<AppointmentsModel> getAppointmentById(String id);

  // الحصول على مواعيد المستخدم
  Future<List<AppointmentsModel>> getUserAppointments(String userId);

  // الحصول على مواعيد المستخدم بشكل real-time
  Stream<List<AppointmentsModel>> getUserAppointmentsStream(String userId);

  // الحصول على مواعيد الطبيب
  Future<List<AppointmentsModel>> getDoctorAppointments(String doctorId);

  // تحديث موعد
  Future<AppointmentsModel> updateAppointment(AppointmentsModel appointment);

  // حذف موعد
  Future<void> deleteAppointment(String id);

  // إلغاء موعد
  Future<AppointmentsModel> cancelAppointment(String id, String cancelledBy);

  // إعادة جدولة موعد
  Future<AppointmentsModel> rescheduleAppointment(
    String id,
    DateTime newDate,
    String newTime,
    String rescheduledBy,
  );
}

class AppointmentsDatasourceImpl implements AppointmentsDatasource {
  final SupabaseClient client = SupabaseHelper.client;

  static const String tableName = 'appointments';
  static const String viewTable = 'appointment_view';

  @override
  Future<AppointmentsModel> createAppointment(
    AppointmentsModel appointment,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(tableName)
          .insert(appointment.toJson())
          .select()
          .single();
      return AppointmentsModel.fromJson(response);
    });
  }

  @override
  Future<AppointmentsModel> getAppointmentById(String id) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .eq('id', id)
          .single();

      return AppointmentsModel.fromJson(response);
    });
  }

  @override
  Future<List<AppointmentsModel>> getUserAppointments(String userId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(viewTable)
          .select()
          .eq('user_id', userId)
          .order('date', ascending: true);

      return (response as List)
          .map((json) => AppointmentsModel.fromJson(json))
          .toList();
    });
  }

  @override
  Stream<List<AppointmentsModel>> getUserAppointmentsStream(String userId) {
    final controller = StreamController<List<AppointmentsModel>>.broadcast();

    // تحميل البيانات الأولية - Load initial data
    _loadInitialData(userId, controller);

    // إنشاء قناة للاستماع للتغييرات - Create channel to listen for changes
    final channel = client
        .channel('appointments_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: tableName, // استخدام TABLE وليس VIEW - Use TABLE not VIEW
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            // إعادة تحميل البيانات عند حدوث تغيير - Reload data on change
            _loadInitialData(userId, controller);
          },
        )
        .subscribe(); // ✅ تفعيل الاشتراك - Activate subscription

    // إلغاء الاشتراك عند إغلاق الـ stream - Cancel subscription when stream closes
    controller.onCancel = () {
      client.removeChannel(channel);
    };

    return controller.stream;
  }

  Future<void> _loadInitialData(
    String userId,
    StreamController<List<AppointmentsModel>> controller,
  ) async {
    try {
      // جلب البيانات من الـ VIEW - Fetch data from VIEW
      final data = await client
          .from(viewTable)
          .select()
          .eq('user_id', userId)
          .order('date', ascending: true);

      // تحويل البيانات إلى نماذج - Convert data to models
      final appointments = (data as List)
          .map((json) => AppointmentsModel.fromJson(json))
          .toList();

      // إضافة البيانات إلى الـ stream - Add data to stream
      if (!controller.isClosed) {
        controller.add(appointments);
      }
    } catch (e) {
      // إضافة الخطأ إلى الـ stream - Add error to stream
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }
  }

  @override
  Future<List<AppointmentsModel>> getDoctorAppointments(String doctorId) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(tableName)
          .select()
          .eq('doctor_id', doctorId);

      return (response as List)
          .map((json) => AppointmentsModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<AppointmentsModel> updateAppointment(
    AppointmentsModel appointment,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(tableName)
          .update(appointment.toJson())
          .eq('id', appointment.id!)
          .select()
          .single();

      return AppointmentsModel.fromJson(response);
    });
  }

  @override
  Future<void> deleteAppointment(String id) async {
    return await SupabaseHelper.executeQuery(() async {
      await client.from(tableName).delete().eq('id', id);
    });
  }

  @override
  Future<AppointmentsModel> cancelAppointment(
    String id,
    String cancelledBy,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      // تحديث حالة الموعد إلى ملغي - Update appointment status to cancelled
      await client
          .from(tableName)
          .update({
            'status': 'cancelled',
            'cancelled_by': cancelledBy,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      // جلب البيانات المحدثة من الـ VIEW - Fetch updated data from VIEW
      final response = await client
          .from(viewTable)
          .select()
          .eq('id', id)
          .single();

      return AppointmentsModel.fromJson(response);
    });
  }

  @override
  Future<AppointmentsModel> rescheduleAppointment(
    String id,
    DateTime newDate,
    String newTime,
    String rescheduledBy,
  ) async {
    return await SupabaseHelper.executeQuery(() async {
      final response = await client
          .from(tableName)
          .update({
            'date': newDate.toIso8601String().split('T')[0],
            'time': newTime,
            'status': 'rescheduled',
            'rescheduled_by': rescheduledBy,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return AppointmentsModel.fromJson(response);
    });
  }
}
