import 'package:flutter/material.dart';

class AppTheme {
  // Design tokens - Colors
  static const Color primaryColor2 = Color(0xFF014737); // Teal
  static const Color primaryColor = Color(0xFF1C2A3A); // Teal
  static const Color accentColor = Color(0xFF4D9B91);
  static const Color backgroundColor = Color(0xFFFFFFFF); // Light gray
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFC2B3038); // Dark gray
  static const Color textSecondary = Color(0xFF757575); // Medium gray
  static const Color dividerColor = Color(0xD0E5E5E5);
  static const Color errorColor = Color(0xD0FF0000);

  // Category Colors
  static const Color categoryPink = Color(0xFFDC9497);
  static const Color categoryGreen = Color(0xFF93C19E);
  static const Color categoryOrange = Color(0xFFF5AD7E);
  static const Color categoryPurple = Color(0xFFACA1CD);
  static const Color categoryTeal = Color(0xFF4D9B91);
  static const Color categoryNavy = Color(0xFF352261);
  static const Color categoryBeige = Color(0xFFDEB6B5);
  static const Color categoryLightBlue = Color(0xFF89CCDB);

  // Design tokens - Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Design tokens - Border radius
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 24.0;

  // Design tokens - Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color.fromARGB(255, 139, 139, 139).withValues(alpha: 0.5),
      blurRadius: 5,
      offset: const Offset(0, 4),
    ),
  ];

  // Typography
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor2,
      scaffoldBackgroundColor: backgroundColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineLarge: heading1,
        headlineMedium: heading2,
        titleLarge: sectionTitle,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelSmall: caption,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor2,
        primary: primaryColor2,
        secondary: accentColor,
        surface: cardBackground,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor2,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
