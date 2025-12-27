# DateFormatter - أداة تنسيق التاريخ

## الوصف
`DateFormatter` هي أداة مركزية لتنسيق التواريخ والأوقات في التطبيق بشكل موحد.

## الاستخدام

### 1. استيراد الأداة
```dart
import 'package:doctorbooking/core/utils/date_formatter.dart';
```

### 2. التنسيقات المتاحة

#### تنسيق قصير (MMM dd)
```dart
final date = DateTime(2024, 1, 15);
final formatted = DateFormatter.formatShort(date);
// النتيجة: "Jan 15"
```

#### تنسيق كامل (MMMM dd, yyyy)
```dart
final formatted = DateFormatter.formatFull(date);
// النتيجة: "January 15, 2024"
```

#### تنسيق رقمي (dd/MM/yyyy)
```dart
final formatted = DateFormatter.formatNumeric(date);
// النتيجة: "15/01/2024"
```

#### تنسيق ISO (yyyy-MM-dd)
```dart
final formatted = DateFormatter.formatISO(date);
// النتيجة: "2024-01-15"
```

#### تنسيق مع اسم اليوم
```dart
final formatted = DateFormatter.formatWithDay(date);
// النتيجة: "Mon, Jan 15"
```

### 3. تنسيق الوقت

#### وقت 24 ساعة (HH:mm)
```dart
final time = DateTime(2024, 1, 15, 14, 30);
final formatted = DateFormatter.formatTime24(time);
// النتيجة: "14:30"
```

#### وقت 12 ساعة (hh:mm AM/PM)
```dart
final formatted = DateFormatter.formatTime12(time);
// النتيجة: "02:30 PM"
```

#### تاريخ ووقت معاً
```dart
final formatted = DateFormatter.formatDateTime(time);
// النتيجة: "Jan 15, 14:30"
```

### 4. التنسيق الذكي

#### تنسيق نسبي (Relative Time)
```dart
final yesterday = DateTime.now().subtract(Duration(days: 1));
final formatted = DateFormatter.getRelativeTime(yesterday);
// النتيجة: "1 day ago"

final twoHoursAgo = DateTime.now().subtract(Duration(hours: 2));
final formatted = DateFormatter.getRelativeTime(twoHoursAgo);
// النتيجة: "2 hours ago"
```

#### تنسيق ذكي (Today/Tomorrow/Yesterday)
```dart
final today = DateTime.now();
final formatted = DateFormatter.formatSmart(today);
// النتيجة: "Today"

final tomorrow = DateTime.now().add(Duration(days: 1));
final formatted = DateFormatter.formatSmart(tomorrow);
// النتيجة: "Tomorrow"

final someDate = DateTime(2024, 1, 15);
final formatted = DateFormatter.formatSmart(someDate);
// النتيجة: "Jan 15"
```

### 5. دوال التحقق

#### التحقق من اليوم
```dart
final today = DateTime.now();
final isToday = DateFormatter.isToday(today);
// النتيجة: true
```

#### التحقق من الغد
```dart
final tomorrow = DateTime.now().add(Duration(days: 1));
final isTomorrow = DateFormatter.isTomorrow(tomorrow);
// النتيجة: true
```

#### التحقق من الأمس
```dart
final yesterday = DateTime.now().subtract(Duration(days: 1));
final isYesterday = DateFormatter.isYesterday(yesterday);
// النتيجة: true
```

## أمثلة عملية

### في بطاقة الموعد
```dart
Widget buildAppointmentCard(AppointmentsModel appointment) {
  final formattedDate = DateFormatter.formatShort(appointment.date);
  final formattedTime = appointment.time;
  
  return Card(
    child: Column(
      children: [
        Text('Date: $formattedDate'),
        Text('Time: $formattedTime'),
      ],
    ),
  );
}
```

### في قائمة المواعيد
```dart
Widget buildAppointmentsList(List<AppointmentsModel> appointments) {
  return ListView.builder(
    itemCount: appointments.length,
    itemBuilder: (context, index) {
      final appointment = appointments[index];
      final smartDate = DateFormatter.formatSmart(appointment.date);
      
      return ListTile(
        title: Text(smartDate), // "Today", "Tomorrow", أو "Jan 15"
        subtitle: Text(appointment.time),
      );
    },
  );
}
```

### في تفاصيل الموعد
```dart
Widget buildAppointmentDetails(AppointmentsModel appointment) {
  final fullDate = DateFormatter.formatFull(appointment.date);
  final time12 = DateFormatter.formatTime12(
    DateTime(2024, 1, 1, 
      int.parse(appointment.time.split(':')[0]),
      int.parse(appointment.time.split(':')[1])
    )
  );
  
  return Column(
    children: [
      Text('Full Date: $fullDate'), // "January 15, 2024"
      Text('Time: $time12'), // "02:30 PM"
    ],
  );
}
```

## الفوائد

1. ✅ **توحيد التنسيق**: جميع التواريخ في التطبيق تستخدم نفس التنسيق
2. ✅ **سهولة الصيانة**: تغيير التنسيق في مكان واحد يؤثر على كل التطبيق
3. ✅ **لا حاجة لمكتبات خارجية**: لا يعتمد على `intl` أو مكتبات أخرى
4. ✅ **أداء أفضل**: تنسيق بسيط وسريع
5. ✅ **مرونة**: دوال متعددة لحالات استخدام مختلفة

## ملاحظات

- استخدم `formatShort()` للعرض في البطاقات والقوائم
- استخدم `formatFull()` للعرض في صفحات التفاصيل
- استخدم `formatSmart()` لتجربة مستخدم أفضل (Today/Tomorrow)
- استخدم `formatISO()` عند الإرسال إلى API
- استخدم `getRelativeTime()` للإشعارات والتعليقات
