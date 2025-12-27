# Home Cubit - إدارة حالة الصفحة الرئيسية

## الوصف
يدير `HomeCubit` حالة الصفحة الرئيسية ويجلب مواعيد المستخدم من قاعدة البيانات.

## الميزات
- جلب مواعيد المستخدم
- إعادة تحميل المواعيد
- معالجة الأخطاء
- استخدام معرف مستخدم مؤقت

## الاستخدام

### 1. في الصفحة
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/service_locator.dart';
import '../cubit/home_cubit/home_cubit.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..fetchUserAppointments(),
      child: Scaffold(
        body: // Your UI here
      ),
    );
  }
}
```

### 2. في الويدجت
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit/home_cubit.dart';
import '../cubit/home_cubit/home_state.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return CircularProgressIndicator();
        }
        
        if (state is HomeError) {
          return Text('Error: ${state.message}');
        }
        
        if (state is HomeAppointmentsLoaded) {
          return ListView.builder(
            itemCount: state.appointments.length,
            itemBuilder: (context, index) {
              final appointment = state.appointments[index];
              return ListTile(
                title: Text('Doctor: ${appointment.doctorId}'),
                subtitle: Text('${appointment.date} - ${appointment.time}'),
              );
            },
          );
        }
        
        return SizedBox.shrink();
      },
    );
  }
}
```

### 3. إعادة تحميل المواعيد
```dart
ElevatedButton(
  onPressed: () {
    context.read<HomeCubit>().refreshAppointments();
  },
  child: Text('Refresh'),
)
```

## الحالات (States)

### HomeInitial
الحالة الأولية قبل جلب البيانات.

### HomeLoading
حالة التحميل أثناء جلب المواعيد.

### HomeAppointmentsLoaded
حالة نجاح تحميل المواعيد.
- `appointments`: قائمة المواعيد

### HomeError
حالة الخطأ عند فشل جلب المواعيد.
- `message`: رسالة الخطأ

## معرف المستخدم المؤقت
يستخدم `HomeCubit` معرف مستخدم مؤقت:
```dart
static const String tempUserId = 'omar-khalid-temp-id';
```

لتغيير معرف المستخدم، قم بتعديل هذا الثابت في `home_cubit.dart`.

## الأمثلة
راجع الملفات التالية للأمثلة الكاملة:
- `lib/features/home/presentation/pages/home_appointments_example.dart`
- `lib/features/home/presentation/widgets/home/appointments_list_widget.dart`
