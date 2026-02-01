import 'package:doctorbooking/features/shared/doctors/data/model/doctor_model.dart';
import 'package:doctorbooking/features/home/data/models/doctor_info_model.dart';
import 'package:doctorbooking/features/shared/appointments/data/models/doctor_schedule_model.dart';
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
  final List<DoctorScheduleModel> schedules;
  final bool isLoadingSchedules;
  final String? scheduleError;

  const DoctorDetailLoaded({
    required this.doctor, 
    required this.doctorInfo,
    this.schedules = const [],
    this.isLoadingSchedules = false,
    this.scheduleError,
  });

  @override
  List<Object?> get props => [doctor, doctorInfo, schedules, isLoadingSchedules, scheduleError];

  DoctorDetailLoaded copyWith({
    DoctorModel? doctor,
    DoctorInfoModel? doctorInfo,
    List<DoctorScheduleModel>? schedules,
    bool? isLoadingSchedules,
    String? scheduleError,
  }) {
    return DoctorDetailLoaded(
      doctor: doctor ?? this.doctor,
      doctorInfo: doctorInfo ?? this.doctorInfo,
      schedules: schedules ?? this.schedules,
      isLoadingSchedules: isLoadingSchedules ?? this.isLoadingSchedules,
      scheduleError: scheduleError ?? this.scheduleError,
    );
  }
}

// حالة الخطأ
class DoctorDetailError extends DoctorDetailState {
  final String message;

  const DoctorDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
