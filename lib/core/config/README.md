# Supabase Configuration / إعدادات Supabase

## ملف الإعدادات / Configuration File

يحتوي ملف `supabase_config.dart` على إعدادات الاتصال بـ Supabase.

The `supabase_config.dart` file contains Supabase connection settings.

## المعلومات المطلوبة / Required Information

- **Project URL**: رابط مشروع Supabase
- **Anon Key**: مفتاح الوصول العام

## الأمان / Security

⚠️ **ملاحظة هامة / Important Note:**

في بيئة الإنتاج، يجب تخزين هذه المعلومات في متغيرات البيئة وليس في الكود مباشرة.

In production, these credentials should be stored in environment variables, not hardcoded.

## الاستخدام / Usage

```dart
// تهيئة Supabase في main.dart
await SupabaseConfig.initialize();

// الوصول إلى العميل
final client = SupabaseConfig.client;
```

## التطوير / Development

لتفعيل وضع التطوير (debug mode):

```dart
static Future<void> initialize() async {
  await Supabase.initialize(
    url: projectUrl,
    anonKey: anonKey,
    debug: true, // تفعيل وضع التطوير
  );
}
```
