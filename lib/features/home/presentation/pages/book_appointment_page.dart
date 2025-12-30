import 'package:doctorbooking/core/services/service_locator.dart';
import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:doctorbooking/core/widgets/custom_app_bar.dart';
import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_cubit.dart';
import 'package:doctorbooking/features/home/presentation/cubit/book_appointment_cubit/book_appointment_state.dart';
import 'package:doctorbooking/features/home/presentation/widgets/appointment/appointment_date_table.dart';
import 'package:doctorbooking/features/home/presentation/widgets/appointment/doctor_booking_bottom_bar.dart';
import 'package:doctorbooking/features/home/presentation/widgets/appointment/time_slot_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookAppointmentCubit(repository: sl())..initData(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'حجز موعد', showleading: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing24)),
              SliverToBoxAdapter(child: AppointmentDateTable()),
              SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing32)),
              SliverToBoxAdapter(
                child: Text(
                  'اختر الوقت',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacing16)),
              TimeSlotGrid(),
            ],
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
              builder: (context, state) {
                final cubit = context.read<BookAppointmentCubit>();
                if (state is BookAppointmentLoading) {
                  return DoctorBookingBottomBar(
                    title: 'تأكيد',
                    onBookPressed: () => cubit.createAppointment(
                      doctorId: cubit.doctorModel.id.toString(),
                    ),
                    canBook: true,
                    isLoading: true,
                  );
                }
                if (state is BookAppointmentError) {
                  return DoctorBookingBottomBar(
                    color: AppTheme.errorColor,
                    title: state.message,
                    onBookPressed: () => cubit.createAppointment(
                      doctorId: cubit.doctorModel.id.toString(),
                    ),
                    canBook: true,
                    isLoading: false,
                  );
                } else {
                  return DoctorBookingBottomBar(
                    title: 'تأكيد',
                    onBookPressed: () => cubit.createAppointment(
                      doctorId: cubit.doctorModel.id.toString(),
                    ),
                    canBook: true,
                    isLoading: false,
                  );
                }
              },
            ),
      ),
    );
  }
}
