import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/screens/auth/login_screen.dart';
import 'package:todo/screens/onboarding/onboarding_screen.dart';
import 'package:todo/screens/onboarding/user_profile_screen.dart';
import 'package:todo/screens/home/home.dart';
import 'package:todo/screens/addTask/taskadd.dart';
import 'package:todo/components/monthlycalendar.dart';
import 'package:todo/screens/profile_screen.dart';
import 'package:todo/screens/settings_screen.dart';
import 'package:todo/screens/timer/timescreen.dart';
import 'package:todo/services/onboarding_service.dart';

class AppRouter {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth state stream
  static Stream<User?> get authStateStream => _auth.authStateChanges();

  // Check if user is authenticated
  static bool _isAuthenticated() {
    return _auth.currentUser != null;
  }

  // Redirect function for authentication and onboarding
  static Future<String?> _authGuard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isAuthenticated = _isAuthenticated();
    final location = state.matchedLocation;
    final isOnboardingRoute = location == '/onboarding';
    final isLoginRoute = location == '/login';
    final isUserProfileRoute = location == '/user-profile';

    // Check onboarding status
    final onboardingCompleted = await OnboardingService.isOnboardingCompleted();

    // Not authenticated: only allow /login and /onboarding
    if (!isAuthenticated) {
      if (!isLoginRoute && !isOnboardingRoute) {
        // print('[Guard] Redirect: not authenticated, go to /login');
        return '/login';
      }
      // Allow navigation to login or onboarding
      return null;
    }

    // Authenticated but onboarding not completed
    if (!onboardingCompleted) {
      // Only allow /onboarding and /user-profile
      if (!isOnboardingRoute && !isUserProfileRoute) {
        // print('[Guard] Redirect: onboarding not completed, go to /onboarding');
        return '/onboarding';
      }
      // If on /onboarding, check if profile is completed
      if (isOnboardingRoute) {
        final profileCompleted =
            await OnboardingService.isUserProfileCompleted();
        // print('[Guard] profileCompleted: $profileCompleted');
        if (!profileCompleted && !isUserProfileRoute) {
          // print('[Guard] Redirect: profile not completed, go to /user-profile');
          return '/user-profile';
        }
        // Allow staying on /onboarding or /user-profile
        return null;
      }
      // If on /user-profile, allow user to complete profile
      if (isUserProfileRoute) {
        return null;
      }
    }

    // Onboarding completed, but profile not completed
    final profileCompleted = await OnboardingService.isUserProfileCompleted();
    if (!profileCompleted) {
      if (!isUserProfileRoute) {
        // print('[Guard] Redirect: profile not completed, go to /user-profile');
        return '/user-profile';
      }
      // Allow staying on /user-profile
      return null;
    }

    // Authenticated, onboarding and profile completed
    // Prevent navigating to login, onboarding, or user-profile
    if (isLoginRoute || isOnboardingRoute || isUserProfileRoute) {
      // print(
      //   '[Guard] Redirect: already onboarded and profile complete, go to /',
      // );
      return '/';
    }

    print('[Guard] No redirect needed for: $location');
    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: _authGuard,
    routes: [
      // Onboarding route
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // User profile setup route
      GoRoute(
        path: '/user-profile',
        name: 'user-profile',
        builder: (context, state) => const UserProfileScreen(),
      ),

      // Protected routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'add-task',
            name: 'add-task',
            builder: (context, state) => const TaskAddScreen(),
          ),
          GoRoute(
            path: 'edit-task',
            name: 'edit-task',
            builder: (context, state) {
              final taskData = state.extra as Map<String, dynamic>?;
              return TaskAddScreen(taskedit: taskData);
            },
          ),
          GoRoute(
            path: 'calendar',
            name: 'calendar',
            builder: (context, state) => const MonthlyCalendar(),
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'timer-task',
            name: 'timer-task',
            builder: (context, state) => TimerScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found${state.uri}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
