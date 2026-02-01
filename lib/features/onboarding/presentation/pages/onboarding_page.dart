import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routing/presentation/routes/app_routes.dart';
import '../../data/datasources/local_onboarding_data.dart';
import '../../data/model/onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = true;
  List<OnboardingModel> _screens = [];

  @override
  void initState() {
    super.initState();
    _loadOnboardingScreens();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadOnboardingScreens() async {
    final dataSource = OnboardingLocalDataSourceImpl();
    final screens = await dataSource.getOnboardingScreens();

    setState(() {
      _screens = screens;
      _isLoading = false;
    });
  }

  void _nextPage() {
    if (_currentPage < _screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to main app
      Get.offAllNamed(AppRoutes.navigationPage);
    }
  }

  void _skipOnboarding() {
    Get.offAllNamed(AppRoutes.navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _screens.length,
              itemBuilder: (context, index) {
                final screen = _screens[index];
                return _OnboardingScreenItem(
                  screen: screen,
                  currentPage: _currentPage,
                  nextPage: _nextPage,
                  screens: _screens,
                  skipOnboarding: _skipOnboarding,
                  index: index,
                );
              },
            ),
          ),
      
      
        ],
      ),
    );
  }
}

class _OnboardingScreenItem extends StatefulWidget {
  final OnboardingModel screen;
  final  int currentPage ;
  final List screens ;
  final Function nextPage;
  final Function skipOnboarding;
  final int index;

  const _OnboardingScreenItem({required this.screen , required this.currentPage,required this.screens, required this.nextPage, required this.skipOnboarding, required this.index,});

  @override
  State<_OnboardingScreenItem> createState() => _OnboardingScreenItemState();
}

class _OnboardingScreenItemState extends State<_OnboardingScreenItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuad,
    ));

    // Start animation when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void didUpdateWidget(covariant _OnboardingScreenItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart animation when page changes
    if (oldWidget.index != widget.index) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Illustration/Image with animation
        FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Positioned(
              top: 0,
              child: SizedBox(
                height: Get.height * 0.6,
                width: Get.width,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.screen.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: AppTheme.secondaryTextColor,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Content container with animations
        Positioned(
          top: Get.height * 0.58,
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium,),
              color: AppTheme.backgroundColor
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.screen.title,
                      textAlign: TextAlign.center,
                      style: AppTheme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
              
                    const SizedBox(height: 16),
              
                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        widget.screen.subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: AppTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.secondaryTextColor,
                          height: 1.3,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bottom controls
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          // Page indicators
                          ElevatedButton(
                            onPressed: () => widget.nextPage(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: AppTheme.backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 130,
                                vertical: 18,
                              ),
                            ),

                            child: Text(
                              widget.currentPage == widget.screens.length - 1
                                  ? 'ابدأ الآن'
                                  : 'التالي',
                              style: AppTheme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w200,
                                color: AppTheme.backgroundColor,
                              ),
                            ),
                          ),

                          SizedBox(height: 25),

                          // Next
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(widget.screens.length, (index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: widget.currentPage == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: widget.currentPage == index
                                      ? AppTheme.primaryColor
                                      : AppTheme.secondaryTextColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 20),

                          ///Skip button
                          TextButton(
                            onPressed:() =>  widget.skipOnboarding(),
                            child: Text(
                              'تخطي',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
