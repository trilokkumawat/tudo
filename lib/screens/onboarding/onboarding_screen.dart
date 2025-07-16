import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/custom_button.dart';
import 'package:todo/services/onboarding_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Todo App',
      subtitle: 'Organize your life, one task at a time',
      description:
          'Stay productive and organized with our intuitive todo app designed to help you manage your daily tasks efficiently.',
      icon: Icons.task_alt,
      color: const Color(0xFF12272F),
    ),
    OnboardingPage(
      title: 'Smart Task Management',
      subtitle: 'Create, organize, and track your tasks',
      description:
          'Add tasks with notes, set reminders, and track your progress. Filter tasks by status and never miss a deadline.',
      icon: Icons.check_circle_outline,
      color: const Color(0xFF12272F),
    ),
    OnboardingPage(
      title: 'Secure & Private',
      subtitle: 'Your data is safe with us',
      description:
          'All your tasks are securely stored in the cloud and synced across all your devices. Your privacy is our priority.',
      icon: Icons.security,
      color: const Color(0xFF12272F),
    ),
    OnboardingPage(
      title: 'Ready to Get Started?',
      subtitle: 'Sign in with Google to begin',
      description:
          'Join thousands of users who are already organizing their lives with our todo app. Get started in seconds.',
      icon: Icons.rocket_launch,
      color: const Color(0xFF12272F),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () async {
                    await OnboardingService.markOnboardingCompleted();
                    if (mounted) {
                      context.go('/login');
                    }
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF12272F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 60, color: page.color),
                        ),
                        const SizedBox(height: 32),

                        // Title
                        Text(
                          page.title,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF12272F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          page.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: page.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          page.description,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Navigation
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _previousPage,
                      child: Text(
                        'Previous',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF12272F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  // Page indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? const Color(0xFF12272F)
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),

                  // Next/Get Started button
                  _currentPage == _pages.length - 1
                      ? Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF12272F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              await OnboardingService.markOnboardingCompleted();
                              if (mounted) {
                                context.go('/login');
                              }
                            },
                            child: Text(
                              'Get Started',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: _nextPage,
                          child: Text(
                            'Next',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF12272F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}
