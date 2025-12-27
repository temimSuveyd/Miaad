import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LocationTabWidget extends StatelessWidget {
  final String practicePlace;
  final double? latitude;
  final double? longitude;

  const LocationTabWidget({
    super.key,
    required this.practicePlace,
    this.latitude,
    this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Practice Place',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            practicePlace,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),
          const Text(
            'Location Map',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Stack(
                children: [
                  // Placeholder for map - will be replaced with actual map widget
                  Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 60,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Map will be integrated here',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // You can integrate Google Maps or other map widget here
                  // Example with placeholder image simulating a map
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}