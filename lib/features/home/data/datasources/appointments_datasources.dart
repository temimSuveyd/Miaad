import 'dart:async';
import 'dart:developer';

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
    // Broadcast controller kullan - birden fazla listener için
    final controller = StreamController<List<AppointmentsModel>>.broadcast();

    log('🔵 Setting up real-time stream for user: $userId');

    // İlk veriyi yükle
    _loadInitialData(userId, controller);

    // Real-time dinle - VIEW değil TABLE'ı dinlemeliyiz
    final channel = client
        .channel('appointments_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: tableName, // VIEW değil TABLE
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            log(
              '🟢 Real-time event received: ${payload.eventType} for record: ${payload.newRecord?['id']}',
            );
            log('🔄 Reloading appointments from view...');
            _loadInitialData(userId, controller);
          },
        )
        .subscribe((status, error) {
          log('📡 Channel subscription status: $status');
          if (error != null) {
            log('❌ Channel subscription error: $error');
          }
        });

    // Cleanup
    controller.onCancel = () {
      log('🔴 Cancelling stream subscription');
      client.removeChannel(channel);
    };

    return controller.stream;
  }

  Future<void> _loadInitialData(
    String userId,
    StreamController<List<AppointmentsModel>> controller,
  ) async {
    try {
      log('Loading appointments from view for user: $userId');

      final data = await client
          .from(viewTable)
          .select()
          .eq('user_id', userId)
          .order('date', ascending: true);

      final appointments = (data as List)
          .map((json) => AppointmentsModel.fromJson(json))
          .toList();

      log('Loaded ${appointments.length} appointments');

      if (!controller.isClosed) {
        controller.add(appointments);
      }
    } catch (e) {
      log('Error loading appointments: $e');
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
      log('Cancelling appointment: $id');

      // appointments tablosunu güncelle
      await client
          .from(tableName)
          .update({
            'status': 'cancelled',
            'cancelled_by': cancelledBy,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      log('Appointment cancelled in database, fetching updated data from view');

      // Güncellenmiş veriyi view'dan çek
      final response = await client
          .from(viewTable)
          .select()
          .eq('id', id) // ✅ Doğru kolon adı
          .single();

      log('Updated appointment fetched: ${response['status']}');
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
