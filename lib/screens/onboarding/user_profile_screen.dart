import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/custom_button.dart';
import 'package:todo/components/custom_text_field.dart';
import 'package:todo/services/auth_service.dart';
import 'package:todo/services/onboarding_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with Google display name if available
    final displayName = _authService.userDisplayName;
    if (displayName != null && displayName.isNotEmpty) {
      _displayNameController.text = displayName;
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Here you could save additional user data to Firestore
      // For now, we'll just mark the profile as completed
      await OnboardingService.markUserProfileCompleted();

      if (mounted) {
        context.go('/');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile setup completed!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Welcome message
                  Text(
                    'Welcome!',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF12272F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s set up your profile',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // User avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF12272F),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: user?.photoURL != null
                          ? Image.network(
                              user!.photoURL!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFF12272F),
                                  child: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: const Color(0xFF12272F),
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User info card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Information',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF12272F),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Email
                          ListTile(
                            leading: const Icon(
                              Icons.email,
                              color: Color(0xFF12272F),
                            ),
                            title: Text(
                              'Email',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              user?.email ?? 'No email',
                              style: GoogleFonts.inter(color: Colors.grey[600]),
                            ),
                          ),

                          // Display name input
                          const SizedBox(height: 16),
                          CustomTextField(
                            labelText: 'Display Name',
                            hintText: 'Enter your display name',
                            controller: _displayNameController,
                            readOnly: true,

                            // validator: (value) {
                            //   if (value == null || value.trim().isEmpty) {
                            //     return 'Display name is required';
                            //   }
                            //   if (value.trim().length < 2) {
                            //     return 'Display name must be at least 2 characters';
                            //   }
                            //   return null;
                            // },
                          ),

                          const SizedBox(height: 16),

                          // Account creation date
                          ListTile(
                            leading: const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF12272F),
                            ),
                            title: Text(
                              'Member Since',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              user?.metadata.creationTime != null
                                  ? '${user!.metadata.creationTime!.day}/${user.metadata.creationTime!.month}/${user.metadata.creationTime!.year}'
                                  : 'Unknown',
                              style: GoogleFonts.inter(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Privacy notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12272F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.security, color: Color(0xFF12272F)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your data is secure and private. We only collect information necessary to provide you with the best experience.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Complete profile button
                  CustomButton(
                    text: 'Complete Setup',
                    onPressed: _isLoading ? null : _completeProfile,
                    isLoading: _isLoading,
                    icon: Icons.check,
                  ),

                  const SizedBox(height: 16),

                  // Skip option
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            await OnboardingService.markUserProfileCompleted();
                            if (mounted) {
                              context.go('/');
                            }
                          },
                    child: Text(
                      'Skip for now',
                      style: GoogleFonts.inter(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
