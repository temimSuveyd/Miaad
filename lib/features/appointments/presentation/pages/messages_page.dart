import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 80, color: AppTheme.primaryColor),
            const SizedBox(height: 16),
            Text('Messages', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
