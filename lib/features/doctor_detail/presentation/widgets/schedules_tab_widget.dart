import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'date_selector_widget.dart';
import 'time_slot_selector_widget.dart';

class SchedulesTabWidget extends StatefulWidget {
  final Function(DateTime, String) onScheduleSelected;

  const SchedulesTabWidget({
    super.key,
    required this.onScheduleSelected,
  });

  @override
  State<SchedulesTabWidget> createState() => _SchedulesTabWidgetState();
}

class _SchedulesTabWidgetState extends State<SchedulesTabWidget> {
  late DateTime selectedDate;
  String selectedPeriod = 'Morning';
  String? selectedTime;
  
  late List<DateTime> availableDates;
  late Map<String, List<String>> timeSlotsByPeriod;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _initializeDates();
    _initializeTimeSlots();
  }

  void _initializeDates() {
    availableDates = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );
  }

  void _initializeTimeSlots() {
    timeSlotsByPeriod = {
      'Morning': ['8:00 AM', '8:30 AM', '8:45 AM', '9:00 AM', '9:30 AM', '10:00 AM'],
      'Afternoon': ['12:00 PM', '12:30 PM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM'],
      'Evening': ['5:00 PM', '5:30 PM', '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM'],
      'Night': ['8:00 PM', '8:30 PM', '9:00 PM', '9:30 PM', '10:00 PM'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          DateSelectorWidget(
            dates: availableDates,
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: AppTheme.spacing24),
          TimeSlotSelectorWidget(
            selectedPeriod: selectedPeriod,
            selectedTime: selectedTime,
            onPeriodSelected: (period) {
              setState(() {
                selectedPeriod = period;
                selectedTime = null;
              });
            },
            onTimeSelected: (time) {
              setState(() {
                selectedTime = time;
                widget.onScheduleSelected(selectedDate, time);
              });
            },
            availableTimes: timeSlotsByPeriod[selectedPeriod] ?? [],
          ),
        ],
      ),
    );
  }
}