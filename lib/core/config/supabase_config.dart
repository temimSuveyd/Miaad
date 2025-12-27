import 'package:supabase_flutter/supabase_flutter.dart';

// إعدادات Supabase
class SupabaseConfig {
  // معلومات المشروع
  static const String projectUrl = 'https://ebokedcqabtqblwmbtes.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVib2tlZGNxYWJ0cWJsd21idGVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3ODcyMzEsImV4cCI6MjA4MjM2MzIzMX0.V7cWqmPvuzcWhyCZTxhKSTFsUsXnkmFyUP1sTmrv07w';

  // تهيئة Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: projectUrl,
      anonKey: anonKey,
      debug: true, // تعيين إلى true للتطوير
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
