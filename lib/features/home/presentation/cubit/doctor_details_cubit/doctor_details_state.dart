import 'package:doctorbooking/features/shared/doctors/data/model/doctor_model.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:equatable/equatable.dart';

// حالات صفحة تفاصيل الطبيب
abstract class DoctorDetailState extends Equatable {
  const DoctorDetailState();

  @override
  List<Object?> get props => [];
}

// الحالة الأولية
class DoctorDetailInitial extends DoctorDetailState {
  const DoctorDetailInitial();
}

// حالة التحميل
class DoctorDetailLoading extends DoctorDetailState {
  const DoctorDetailLoading();
}

// حالة النجاح - عرض بيانات الطبيب
class DoctorDetailLoaded extends DoctorDetailState {
  final DoctorModel doctor;
  final DoctorInfoModel doctorInfo;

  const DoctorDetailLoaded({required this.doctor, required this.doctorInfo});

  @override
  List<Object?> get props => [doctor, doctorInfo];
}

// حالة الخطأ
class DoctorDetailError extends DoctorDetailState {
  final String message;

  const DoctorDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
