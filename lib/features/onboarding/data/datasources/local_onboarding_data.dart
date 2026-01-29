import '../model/onboarding_model.dart';

/// Local data source for onboarding screens
abstract class OnboardingLocalDataSource {
  /// Get all onboarding screens
  Future<List<OnboardingModel>> getOnboardingScreens();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  Future<List<OnboardingModel>> getOnboardingScreens() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      OnboardingModel(
        id: 1,
        title: 'تواصل مع أفضل الأطباء',
        subtitle: 'اكتشف الأطباء المتميزين في سوريا وتواصل معهم مباشرة. احجز المواعيد فوراً وادر مسارك الصحي.',
        imagePath: 'assets/onboarding_images/onboarding_1.png',
      ),
      OnboardingModel(
        id: 2,
        title: 'محادثة مباشرة مع الأطباء',
        subtitle: 'دردش مع أطبائك قبل الموعد بساعة واحدة. احصل على استشارات فورية وإجابات لأسئلتك الطبية.',
        imagePath: 'assets/onboarding_images/onboarding_2.png',
      ),
      OnboardingModel(
        id: 3,
        title: 'أطباءك المفضلون والمجاورون',
        subtitle: 'تصفح أفضل الأطباء في سوريا، اكتشف الأطباء في حيّك، واحفظ أطباءك المفضلين لسهولة الحجز مستقبلاً.',
        imagePath: 'assets/onboarding_images/onboarding_3.png',
      ),
    ];
  }
}