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

// تطبيق مصدر البيانات
class AppointmentsDatasourceImpl implements AppointmentsDatasource {
  final SupabaseClient client = SupabaseHelper.client;
  static const String tableName = 'appointments';

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
          .from(tableName)
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
          .from(tableName)
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
    return client
        .from(tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('date', ascending: true)
        .map((data) {
          return data.map((json) => AppointmentsModel.fromJson(json)).toList();
        });
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
      final response = await client
          .from(tableName)
          .update({
            'status': 'cancelled',
            'cancelled_by': cancelledBy,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
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
