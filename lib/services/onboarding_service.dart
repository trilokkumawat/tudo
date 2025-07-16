import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String _onboardingKey = 'onboarding_completed';
  static const String _userProfileKey = 'user_profile_completed';

  // Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  // Mark onboarding as completed
  static Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  // Check if user profile is completed
  static Future<bool> isUserProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_userProfileKey) ?? false;
  }

  // Mark user profile as completed
  static Future<void> markUserProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_userProfileKey, true);
  }

  // Reset onboarding (for testing or logout)
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingKey);
    await prefs.remove(_userProfileKey);
  }

  // Get onboarding status
  static Future<Map<String, bool>> getOnboardingStatus() async {
    return {
      'onboarding_completed': await isOnboardingCompleted(),
      'profile_completed': await isUserProfileCompleted(),
    };
  }
}
