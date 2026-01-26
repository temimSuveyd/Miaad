import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../../../../../core/models/doctor_model.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../home/presentation/widgets/home/doctor_card_widget.dart';

class SearchResultsListWidget extends StatelessWidget {
  final List<DoctorModel> doctors;

  const SearchResultsListWidget({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16.dp),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppTheme.spacing16.dp),
          child: DoctorCardWidget(
            doctorModel: doctors[index],
            showFavorite: true,
          ),
        );
      },
    );
  }
}
