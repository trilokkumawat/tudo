# Todo App with Google Sign-In & Onboarding

A Flutter todo application with secure Google authentication, comprehensive onboarding flow, and modern routing using go_router.

## Features

### 🔐 **Secure Authentication**
- **Google Sign-In Only**: Secure authentication using Google's OAuth 2.0
- **No Password Storage**: Eliminates password security risks
- **Automatic Session Management**: Persistent authentication state
- **Secure Token Handling**: Uses Firebase Auth with Google credentials

### 🎯 **Onboarding Flow**
- **Multi-step Onboarding**: Beautiful onboarding screens explaining app features
- **User Profile Setup**: New users complete profile setup after sign-in
- **Progressive Disclosure**: Information revealed gradually to avoid overwhelming users
- **Skip Options**: Users can skip onboarding and profile setup

### 🧭 **Smart Navigation & Routing**
- **go_router**: Modern, type-safe routing with deep linking
- **Conditional Routing**: Routes change based on onboarding and authentication status
- **Protected Routes**: All app routes require authentication
- **Automatic Redirects**: Smart redirects based on user state

### 📱 **Screens & Components**
- **Onboarding Screen**: Multi-page introduction to app features
- **Login Screen**: Google Sign-In with security features
- **User Profile Screen**: Profile setup for new users
- **Home Screen**: Main todo list with filtering
- **Task Management**: Create, edit, and organize tasks
- **Profile & Settings**: User account management

### 🎨 **Modern UI Components**
- **SecureAuthMethod**: Reusable Google Sign-In component
- **CustomButton**: Standardized button with loading states
- **CustomTextField**: Consistent text input styling
- **TaskCard**: Reusable task display component
- **OnboardingPage**: Structured onboarding content

### 🔥 **Firebase Integration**
- **Firestore**: Real-time task data storage
- **Google Authentication**: Secure user management
- **Real-time Updates**: Live task list updates
- **User Profile Data**: Secure user information storage

## Project Structure

```
lib/
├── components/              # Reusable UI components
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── task_card.dart
│   └── secure_auth_method.dart
├── router/                 # Navigation configuration
│   └── app_router.dart
├── screens/                # App screens
│   ├── auth/              # Authentication screens
│   │   └── login_screen.dart
│   ├── onboarding/        # Onboarding screens
│   │   ├── onboarding_screen.dart
│   │   └── user_profile_screen.dart
│   ├── home.dart          # Main todo list
│   ├── taskadd.dart       # Add/edit tasks
│   ├── profile_screen.dart
│   └── settings_screen.dart
├── services/              # Business logic
│   ├── auth_service.dart
│   └── onboarding_service.dart
├── utils/                 # Helper utilities
│   ├── datetime_helper.dart
│   └── methodhelper.dart
└── main.dart             # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Firebase project with Google Sign-In enabled
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Enable Google Sign-In in Firebase Console
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update Firebase configuration in `lib/firebase_options.dart`

4. **Configure Google Sign-In**
   - Add SHA-1 fingerprint to Firebase project
   - Configure OAuth consent screen in Google Cloud Console
   - Add authorized domains for web

5. **Run the app**
   ```bash
   flutter run
   ```

## Authentication Flow

### 1. **First Launch**
```
App Launch → Onboarding → Google Sign-In → Profile Setup → Home
```

### 2. **Returning User**
```
App Launch → Google Sign-In → Home (if profile complete)
```

### 3. **New User After Sign-In**
```
Google Sign-In → Profile Setup → Home
```

## Routing Configuration

The app uses intelligent routing with the following structure:

```dart
/                    # Home screen (protected)
├── /onboarding     # Onboarding flow (public)
├── /login          # Google Sign-In (public)
├── /user-profile   # Profile setup (protected)
├── /add-task       # Add new task (protected)
├── /edit-task      # Edit existing task (protected)
├── /calendar       # Calendar view (protected)
├── /profile        # User profile (protected)
└── /settings       # App settings (protected)
```

### Security Features

- **Authentication Guards**: All routes except onboarding and login require authentication
- **Onboarding Guards**: Users see onboarding before authentication
- **Profile Guards**: New users complete profile setup before accessing app
- **Automatic Redirects**: Smart redirects based on user state
- **Session Persistence**: Authentication state maintained across app restarts

## Key Components

### AuthService
Handles all Google authentication operations:
- Google Sign-In with Firebase
- Session management
- User state tracking
- Secure token handling

### OnboardingService
Manages onboarding and profile completion:
- Onboarding status tracking
- Profile completion status
- State persistence
- Reset functionality

### AppRouter
Configures intelligent routing with:
- Authentication guards
- Onboarding guards
- Profile completion checks
- Error handling
- Deep linking support

### SecureAuthMethod
Reusable Google Sign-In component:
- Secure authentication flow
- Loading states
- Error handling
- Security notices

## Features in Detail

### Onboarding Experience
1. **Welcome Screen**: App introduction and value proposition
2. **Feature Highlights**: Key app features explained
3. **Security Information**: Privacy and security details
4. **Get Started**: Call-to-action for Google Sign-In

### Google Sign-In Security
- **OAuth 2.0**: Industry-standard authentication
- **No Password Storage**: Eliminates password risks
- **Secure Tokens**: Firebase handles token security
- **User Consent**: Users control data access
- **Automatic Session**: Seamless re-authentication

### User Profile Setup
- **Google Data Integration**: Pre-fills with Google profile
- **Custom Display Name**: Users can customize their name
- **Privacy Notice**: Clear data usage information
- **Skip Option**: Users can skip profile setup

### Task Management
- **Create Tasks**: Add tasks with title, notes, time, and alarms
- **Edit Tasks**: Modify existing tasks
- **Toggle Status**: Mark tasks as complete/incomplete
- **Filter Tasks**: View All, Complete, or Active tasks
- **Real-time Updates**: Changes sync immediately

## Security Considerations

### Authentication Security
- **Google OAuth 2.0**: Industry-standard authentication
- **Firebase Security**: Google's secure authentication platform
- **Token Management**: Automatic token refresh and validation
- **Session Security**: Secure session handling

### Data Security
- **Firebase Security Rules**: Implement proper Firestore rules
- **Input Validation**: All user inputs validated
- **Error Handling**: Graceful error handling
- **Privacy Protection**: Minimal data collection

### Network Security
- **HTTPS Only**: All communications over HTTPS
- **Secure APIs**: Firebase provides secure APIs
- **Token Encryption**: Tokens encrypted in transit
- **Certificate Pinning**: App validates server certificates

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.15.1
  firebase_auth: ^5.3.3
  cloud_firestore: ^5.6.11
  google_sign_in: ^6.2.1
  go_router: ^14.6.2
  google_fonts: ^6.2.1
  shared_preferences: ^2.3.3
  alarm: ^5.1.4
  intl: ^0.20.2
  flutter_local_notifications: ^19.3.0

```

## Configuration

### Firebase Setup
1. Create Firebase project
2. Enable Google Sign-In
3. Add Android/iOS apps
4. Download configuration files
5. Configure SHA-1 fingerprints

### Google Cloud Console
1. Enable Google Sign-In API
2. Configure OAuth consent screen
3. Add authorized domains
4. Set up OAuth credentials

### Android Configuration
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS Configuration
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>REVERSED_CLIENT_ID</string>
  </dict>
</array>
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.
