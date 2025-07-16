import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/onboarding_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/secure_auth_method.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        if (mounted) {
          // Check if user is new and needs profile setup
          if (userCredential.additionalUserInfo?.isNewUser == true) {
            context.go('/user-profile');
          } else {
            // Check if user profile is completed
            final isProfileCompleted =
                await OnboardingService.isUserProfileCompleted();
            if (!isProfileCompleted) {
              context.go('/user-profile');
            } else {
              context.go('/');
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully signed in!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB), // Soft, modern background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon in a card
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF12272F), // Primary accent
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF12272F).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.task_alt,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // Card for main content
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      // Welcome Text
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF12272F), // Primary accent
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue organizing your tasks',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(
                            0xFF12272F,
                          ), // Use accent for subtitle for bold look
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Google Sign In Button
                      SecureAuthMethod(
                        onSuccess: () async {
                          final user = _authService.currentUser;
                          if (user != null) {
                            final isNewUser = _authService.isNewUser;
                            if (isNewUser) {
                              context.go('/user-profile');
                            } else {
                              final isProfileCompleted =
                                  await OnboardingService.isUserProfileCompleted();
                              if (!isProfileCompleted) {
                                context.go('/user-profile');
                              } else {
                                context.go('/');
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Successfully signed in!'),
                              ),
                            );
                          }
                        },
                        onError: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sign in cancelled or failed'),
                            ),
                          );
                        },
                        showLoading: _isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Privacy Notice
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              size: 18,
                              color: const Color(0xFF12272F), // Primary accent
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Secure Google Sign In. Your data is protected.',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(
                                    0xFF12272F,
                                  ), // Accent for privacy text
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Features
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFeatureItem(
                            icon: Icons.sync,
                            title: 'Sync',
                            description: 'Across Devices',
                          ),
                          _buildFeatureItem(
                            icon: Icons.security,
                            title: 'Private',
                            description: 'Encrypted Data',
                          ),
                          _buildFeatureItem(
                            icon: Icons.speed,
                            title: 'Fast',
                            description: 'Reliable',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(
              0xFF12272F,
            ).withOpacity(0.08), // Accent background
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF12272F),
            size: 20,
          ), // Accent icon
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF12272F), // Accent for feature title
            fontSize: 13,
          ),
        ),
        Text(
          description,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: const Color(
              0xFF12272F,
            ).withOpacity(0.7), // Subtle accent for description
          ),
        ),
      ],
    );
  }
}
