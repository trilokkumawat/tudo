import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/services/onboarding_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create or update user document in Firestore
      final user = userCredential.user;
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
          'creationTime': user.metadata.creationTime?.toIso8601String(),
        }, SetOptions(merge: true));
      }

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        // New user - mark onboarding as not completed
        await OnboardingService.resetOnboarding();
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // Get user ID
  String? get userId => _auth.currentUser?.uid;

  // Get user email
  String? get userEmail => _auth.currentUser?.email;

  // Get user display name
  String? get userDisplayName => _auth.currentUser?.displayName;

  // Get user photo URL
  String? get userPhotoURL => _auth.currentUser?.photoURL;

  // Check if user is new
  bool get isNewUser =>
      _auth.currentUser?.metadata.creationTime ==
      _auth.currentUser?.metadata.lastSignInTime;

  // Get user creation time
  DateTime? get userCreationTime => _auth.currentUser?.metadata.creationTime;

  // Get user last sign in time
  DateTime? get userLastSignInTime =>
      _auth.currentUser?.metadata.lastSignInTime;
}
