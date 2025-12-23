import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'doctor_card_widget.dart';

class PopularDoctorsSectionWidget extends StatelessWidget {
  const PopularDoctorsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {
        'name': 'Dr. Amelia Emma',
        'specialty': 'Gynecologist',
        'rating': 4.9,
        'reviews': 2436,
        'price': '\$25/hr',
        'imageUrl': 'https://images.pexels.com/photos/6749777/pexels-photo-6749777.jpeg?auto=compress&cs=tinysrgb&w=400',
        'backgroundColor': const Color(0xFF5FCDC4),
        'isFavorite': false,
      },
      {
        'name': 'Dr. Daniel Jack',
        'specialty': 'Cardiologist',
        'rating': 4.8,
        'reviews': 1892,
        'price': '\$30/hr',
        'imageUrl': 'https://images.pexels.com/photos/7578806/pexels-photo-7578806.jpeg?auto=compress&cs=tinysrgb&w=400',
        'backgroundColor': const Color(0xFFE8A598),
        'isFavorite': true,
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Doctors',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'See All',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
          child: Column(
            children: doctors.map((doctor) {
              return DoctorCardWidget(
                name: doctor['name'] as String,
                specialty: doctor['specialty'] as String,
                rating: doctor['rating'] as double,
                reviews: doctor['reviews'] as int,
                price: doctor['price'] as String,
                imageUrl: doctor['imageUrl'] as String,
                backgroundColor: doctor['backgroundColor'] as Color,
                isFavorite: doctor['isFavorite'] as bool,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}