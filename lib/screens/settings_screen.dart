import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _soundEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/'),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF12272F),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF12272F),
                      ),
                    ),
                  ],
                ),
              ),

              // Settings Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Notifications Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Notifications',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF12272F),
                                ),
                              ),
                            ),
                            SwitchListTile(
                              title: Text(
                                'Enable Notifications',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Receive reminders for your tasks',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                ),
                              ),
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                              activeColor: const Color(0xFF12272F),
                            ),
                            SwitchListTile(
                              title: Text(
                                'Sound Alerts',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Play sound for notifications',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                ),
                              ),
                              value: _soundEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _soundEnabled = value;
                                });
                              },
                              activeColor: const Color(0xFF12272F),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Appearance Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Appearance',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF12272F),
                                ),
                              ),
                            ),
                            SwitchListTile(
                              title: Text(
                                'Dark Mode',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Use dark theme',
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                ),
                              ),
                              value: _darkModeEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _darkModeEnabled = value;
                                });
                              },
                              activeColor: const Color(0xFF12272F),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Language Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Language',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF12272F),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Language',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                _selectedLanguage,
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                _showLanguageDialog();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Data & Privacy Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Data & Privacy',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF12272F),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.backup_outlined,
                                color: Color(0xFF12272F),
                              ),
                              title: Text(
                                'Backup Data',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Backup feature coming soon!',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFF12272F),
                              ),
                              title: Text(
                                'Clear All Data',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                _showClearDataDialog();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Settings saved successfully!'),
                              ),
                            );
                            context.go('/');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF12272F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save Settings',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Language',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'German', 'Chinese']
              .map(
                (language) => RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear All Data',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will permanently delete all your tasks and data. This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data cleared successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Clear Data',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
