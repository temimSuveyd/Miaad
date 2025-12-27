import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../data/datasources/appointments_datasources.dart';
import '../../data/repositories/appointments_repositories.dart';
import '../cubit/appointments_cubit.dart';
import '../cubit/appointments_state.dart';
import '../widgets/doctor_profile_header_widget.dart';
import '../widgets/doctor_stats_widget.dart';
import '../widgets/about_tab_widget.dart';
import '../widgets/location_tab_widget.dart';
import '../widgets/reviews_tab_widget.dart';
import '../widgets/schedules_tab_widget.dart';

class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentsCubit(
        repository: AppointmentsRepository(
          datasource: AppointmentsDatasourceImpl(),
        ),
      ),
      child: const _DoctorDetailPageContent(),
    );
  }
}

class _DoctorDetailPageContent extends StatefulWidget {
  const _DoctorDetailPageContent();

  @override
  State<_DoctorDetailPageContent> createState() =>
      _DoctorDetailPageContentState();
}

class _DoctorDetailPageContentState extends State<_DoctorDetailPageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // بيانات مؤقتة - سيتم استبدالها بالبيانات الحقيقية
  final String mockUserId = 'user-123-temp';
  final String mockDoctorId = 'doctor-456-temp';

  final Map<String, dynamic> doctorData = {
    'name': 'Prof. Dr. Logan Mason',
    'specialty': 'Dentist',
    'hospital': 'RSUD Gatot Subroto',
    'rating': 4.8,
    'reviewCount': 4279,
    'price': '\$20/hr',
    'imageUrl':
        'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
    'experienceYears': 14,
    'patientsCount': 2456,
    'reviewsCount': 2.4,
    'aboutText':
        'Dr. Jenny Watson is the top most Immunologists specialist in Christ Hospital at London. She achived several awards for her wonderful contribution in medical field. She is available for private consultation.',
    'workingTime': 'Monday - Friday, 08.00 AM - 20.00 PM',
    'strNumber': '4726482464',
    'practicePlace': 'RSPAD Gatot Soebroto',
    'practiceYears': '2017 - sekarang',
    'location': 'Cairo, Egypt',
    'latitude': 30.0444,
    'longitude': 31.2357,
  };

  final List<Map<String, dynamic>> reviewsData = [
    {
      'userName': 'Jane Cooper',
      'userImage': 'https://i.pravatar.cc/100?u=jane',
      'rating': 5.0,
      'reviewText':
          'As someone who lives in a remote area with limited access to healthcare, this telemedicine app has been a game changer for me.',
      'date': 'Today',
    },
    {
      'userName': 'Robert Fox',
      'userImage': 'https://i.pravatar.cc/100?u=robert',
      'rating': 5.0,
      'reviewText':
          'I was initially skeptical about using a telemedicine app but this app has exceeded my expectations.',
      'date': 'Today',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentsCubit, AppointmentsState>(
      listener: (context, state) {
        if (state is AppointmentCreated) {
          SnackbarService.showSuccess(
            context: context,
            title: 'تم الحجز بنجاح!',
            message: 'تم حجز موعدك مع ${doctorData['name']} بنجاح',
          );
          Navigator.pop(context);
        } else if (state is AppointmentsError) {
          SnackbarService.showError(
            context: context,
            title: 'خطأ',
            message: state.message,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            doctorData['name'],
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: AppTheme.textPrimary,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.share_outlined,
                color: AppTheme.textPrimary,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  child: Column(
                    children: [
                      DoctorProfileHeaderWidget(
                        name: doctorData['name'],
                        specialty: doctorData['specialty'],
                        hospital: doctorData['hospital'],
                        rating: doctorData['rating'],
                        reviewCount: doctorData['reviewCount'],
                        imageUrl: doctorData['imageUrl'],
                        onMessageTap: () {},
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      DoctorStatsWidget(
                        experienceYears: doctorData['experienceYears'],
                        patientsCount: doctorData['patientsCount'],
                        reviewsCount: doctorData['reviewsCount'],
                      ),
                      const SizedBox(height: AppTheme.spacing12),
                      TabBar(
                        controller: _tabController,
                        labelColor: AppTheme.primaryColor,
                        unselectedLabelColor: AppTheme.textSecondary,
                        indicatorColor: AppTheme.primaryColor,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Schedules'),
                          Tab(text: 'About'),
                          Tab(text: 'Location'),
                          Tab(text: 'Reviews'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              SchedulesTabWidget(
                onScheduleSelected: (date, time) {
                  context.read<AppointmentsCubit>().selectDateTime(
                    date: date,
                    time: time,
                  );
                },
              ),
              AboutTabWidget(
                aboutText: doctorData['aboutText'],
                workingTime: doctorData['workingTime'],
                strNumber: doctorData['strNumber'],
                practicePlace: doctorData['practicePlace'],
                practiceYears: doctorData['practiceYears'],
              ),
              LocationTabWidget(
                practicePlace: doctorData['location'],
                latitude: doctorData['latitude'],
                longitude: doctorData['longitude'],
              ),
              ReviewsTabWidget(reviews: reviewsData),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<AppointmentsCubit, AppointmentsState>(
          builder: (context, state) {
            final canBook =
                state is AppointmentDateTimeSelected && state.canBook;
            final isLoading = state is AppointmentsLoading;

            return Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primaryColor),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                      child: const Icon(
                        Iconsax.message,
                        color: AppTheme.primaryColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: canBook && !isLoading
                              ? () => _showBookingConfirmation(context, state)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            disabledBackgroundColor: AppTheme.textSecondary
                                .withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMedium,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Book Now',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: AppTheme.backgroundColor,
                                      ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context, AppointmentsState state) {
    if (state is! AppointmentDateTimeSelected) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحجز'),
        content: Text(
          'هل تريد حجز موعد مع ${doctorData['name']} في ${state.selectedDate?.toString().split(' ')[0]} الساعة ${state.selectedTime}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AppointmentsCubit>().createAppointment(
                userId: mockUserId,
                doctorId: mockDoctorId,
                notes: 'موعد مع ${doctorData['name']}',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
