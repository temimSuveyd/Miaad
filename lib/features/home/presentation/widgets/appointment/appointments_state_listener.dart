// import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
// import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../core/services/snackbar_service.dart';


// // مستمع حالة المواعيد
// class AppointmentsStateListener extends StatelessWidget {
//   final Widget child;
//   final String doctorName;

//   const AppointmentsStateListener({
//     super.key,
//     required this.child,
//     required this.doctorName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<BookAppointmentCubit, BookAppointmentState>(
//       listener: (context, state) {
//         _handleState(context, state);
//       },
//       child: child,
//     );
//   }

//   void _handleState(BuildContext context, AppointmentsState state) {
//     if (state is AppointmentCreated) {
//       _handleSuccess(context);
//     } else if (state is AppointmentsError) {
//       _handleError(context, state.message);
//     }
//   }

//   void _handleSuccess(BuildContext context) {
//     SnackbarService.showSuccess(
//       context: context,
//       title: 'تم الحجز بنجاح!',
//       message: 'تم حجز موعدك مع $doctorName بنجاح',
//     );
//     Navigator.pop(context);
//   }

//   void _handleError(BuildContext context, String message) {
//     SnackbarService.showError(context: context, title: 'خطأ', message: message);
//   }
// }
