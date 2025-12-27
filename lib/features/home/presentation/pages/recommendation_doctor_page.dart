import 'package:doctorbooking/core/widgets/custom_app_bar.dart';
import 'package:doctorbooking/core/widgets/text_field.dart';
import 'package:doctorbooking/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/home/doctor_card_widget.dart';

class RecommendationDoctorPage extends StatefulWidget {
  const RecommendationDoctorPage({super.key});

  @override
  State<RecommendationDoctorPage> createState() =>
      _RecommendationDoctorPageState();
}

class _RecommendationDoctorPageState extends State<RecommendationDoctorPage> {
  // Sample data for doctors
  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Randy Wigham',
      'specialty': 'General | RSUD Gatot Subroto',
      'rating': 4.8,
      'reviews': 4279,
      'price': '\$25.00/hr',
      'imageUrl': 'https://via.placeholder.com/150',
      'backgroundColor': const Color(0xFFE8E8E8),
    },
    {
      'name': 'Dr. Jack Suilivan',
      'specialty': 'General | RSUD Gatot Subroto',
      'rating': 4.8,
      'reviews': 4279,
      'price': '\$22.00/hr',
      'imageUrl': 'https://via.placeholder.com/150',
      'backgroundColor': const Color(0xFFD4E4F7),
    },
    {
      'name': 'Dr. Randy Wigham',
      'specialty': 'General | RSUD Gatot Subroto',
      'rating': 4.8,
      'reviews': 4279,
      'price': '\$25.00/hr',
      'imageUrl': 'https://via.placeholder.com/150',
      'backgroundColor': const Color(0xFFD4E4F7),
    },
    {
      'name': 'Dr. Randy Wigham',
      'specialty': 'General | RSUD Gatot Subroto',
      'rating': 4.8,
      'reviews': 4279,
      'price': '\$28.00/hr',
      'imageUrl': 'https://via.placeholder.com/150',
      'backgroundColor': const Color(0xFFD4E4F7),
    },
    {
      'name': 'Dr. Randy Wigham',
      'specialty': 'General | RSUD Gatot Subroto',
      'rating': 4.8,
      'reviews': 4279,
      'price': '\$25.00/hr',
      'imageUrl': 'https://via.placeholder.com/150',
      'backgroundColor': const Color(0xFFE8E8E8),
    },
  ];

  final Set<int> _favorites = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(title: 'Recommendation Doctor'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          // vertical: AppTheme.spacing24,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 10)),
            // Search bar with filter
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(
              child: const SizedBox(height: AppTheme.spacing24),
            ),
            // Doctor list
            SliverList.builder(
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                final doctor = _doctors[index];
                return DoctorCardWidget(
                  showFavorite: false,
doctorModel: DoctorModel.fromJson(doctor),
                  isFavorite: _favorites.contains(index),
                  onFavoriteTap: () {
                    setState(() {
                      if (_favorites.contains(index)) {
                        _favorites.remove(index);
                      } else {
                        _favorites.add(index);
                      }
                    });
                  },
                  onTap: () {
                    // Navigate to doctor detail page
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Row(
              children: [
                CustomTextField(
                  hintText: 'Search',
                  prefixIcon: Iconsax.search_normal,
                ),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Iconsax.filter)),
        ],
      ),
    );
  }
}
