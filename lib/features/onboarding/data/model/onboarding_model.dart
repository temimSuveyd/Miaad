import 'package:equatable/equatable.dart';

/// Model representing an onboarding screen
class OnboardingModel extends Equatable {
  /// Unique identifier for the onboarding screen
  final int id;

  /// Title of the onboarding screen
  final String title;

  /// Subtitle/description of the onboarding screen
  final String subtitle;

  /// Image asset path for the onboarding screen
  final String imagePath;

  const OnboardingModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [id, title, subtitle, imagePath];

  /// Create a copy of the model with updated values
  OnboardingModel copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? imagePath,
  }) {
    return OnboardingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imagePath': imagePath,
    };
  }

  /// Create model from JSON
  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imagePath: json['imagePath'] as String,
    );
  }
}