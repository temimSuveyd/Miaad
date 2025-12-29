import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, size: 80, color: AppTheme.primaryColor2),
            const SizedBox(height: 16),
            Text('Saved', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
