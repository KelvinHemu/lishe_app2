import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
              ),
              const SizedBox(height: 16),
              Text(
                FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn('Posts', '23'),
                  _buildStatColumn('Following', '128'),
                  _buildStatColumn('Followers', '1.2k'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Share Profile'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Sections
          _buildSection(
            context,
            'Health Goals',
            Icons.track_changes,
            'Track and manage your health objectives',
            () {},
          ),
          _buildSection(
            context,
            'Activity History',
            Icons.history,
            'View your past activities and achievements',
            () {},
          ),
          _buildSection(
            context,
            'Saved Items',
            Icons.bookmark,
            'Access your bookmarked content',
            () {},
          ),
          _buildSection(
            context,
            'Settings',
            Icons.settings,
            'Manage your account settings',
            () {},
          ),
          _buildSection(
            context,
            'Help & Support',
            Icons.help,
            'Get assistance and answers to your questions',
            () {},
          ),
          _buildSection(
            context,
            'Logout',
            Icons.logout,
            'Sign out of your account',
            () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login_page');
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 