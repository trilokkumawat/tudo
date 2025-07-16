import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/services/auth_service.dart';

class SecureAuthMethod extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onError;
  final bool showLoading;

  const SecureAuthMethod({
    super.key,
    this.onSuccess,
    this.onError,
    this.showLoading = false,
  });

  @override
  State<SecureAuthMethod> createState() => _SecureAuthMethodState();
}

class _SecureAuthMethodState extends State<SecureAuthMethod> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        widget.onSuccess?.call();
      } else {
        // User cancelled the sign-in
        widget.onError?.call();
      }
    } catch (e) {
      widget.onError?.call();
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
    return Column(
      children: [
        // Google Sign In Button
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading || widget.showLoading
                  ? null
                  : _signInWithGoogle,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading || widget.showLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF12272F),
                          ),
                        ),
                      )
                    else ...[
                      // Google Icon
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/images/google_logo.png',
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.g_mobiledata,
                                color: Colors.white,
                                size: 16,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    const SizedBox(width: 8),
                    Text(
                      _isLoading || widget.showLoading
                          ? 'Signing in...'
                          : 'Continue with Google',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF12272F),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Security notice
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF12272F).withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF12272F).withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.security,
                size: 16,
                color: const Color(0xFF12272F).withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Secure authentication powered by Google',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF12272F).withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
