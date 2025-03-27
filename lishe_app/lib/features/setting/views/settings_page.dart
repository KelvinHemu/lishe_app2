import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _logout(BuildContext context) {
    // Confirm logout
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Perform logout
                  // In a real app, this would call your auth provider's logout method
                  context.go('/welcome');
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account settings
            _buildSectionHeader('Account Settings'),
            _buildSettingTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () => context.go('/profile/edit'),
            ),
            _buildSettingTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage app notifications',
              onTap: () {
                // Navigate to notifications settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification settings coming soon'),
                  ),
                );
              },
            ),

            // Privacy and security
            _buildSectionHeader('Privacy & Security'),
            _buildSettingTile(
              icon: Icons.lock_outline,
              title: 'Privacy and Security',
              subtitle: 'Manage your privacy settings',
              onTap: () {
                // Navigate to privacy settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings coming soon')),
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.password_outlined,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password change feature coming soon'),
                  ),
                );
              },
            ),

            // Support and About
            _buildSectionHeader('Support & Information'),
            _buildSettingTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help with using the app',
              onTap: () {
                // Navigate to help center
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help center coming soon')),
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'Learn more about the app',
              onTap: () {
                _showAboutDialog(context);
              },
            ),

            // App preferences
            _buildSectionHeader('App Preferences'),
            _buildSettingTile(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'Change application language',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language settings coming soon'),
                  ),
                );
              },
            ),
            _buildSettingTile(
              icon: Icons.dark_mode_outlined,
              title: 'Theme',
              subtitle: 'Change app appearance',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme settings coming soon')),
                );
              },
            ),

            // Logout tile
            const SizedBox(height: 24),
            _buildSettingTile(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out from your account',
              onTap: () => _logout(context),
              textColor: Colors.red,
              arrowVisible: false,
            ),

            // App version
            const SizedBox(height: 24),
            Center(
              child: Text(
                'App Version 2.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
    bool arrowVisible = true,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: textColor ?? Colors.grey[700]),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing:
            arrowVisible
                ? Icon(Icons.chevron_right, color: Colors.grey[400])
                : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Lishe App',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.eco, size: 50, color: Colors.green),
      applicationLegalese: '© 2025 Lishe App',
      children: [
        const SizedBox(height: 16),
        const Text(
          'Lishe is a nutrition app designed to help you make healthy food choices and maintain a balanced diet with focus on local Tanzanian foods.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
