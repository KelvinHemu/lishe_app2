import 'package:flutter/material.dart';
import '../../setting/views/settings_page.dart'; // Import the SettingsPage

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  String _username = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you would fetch this from an API or local storage
      // For now, we'll simulate with mock data
      await Future.delayed(const Duration(seconds: 1));

      // Get user data from auth provider
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        _username = authState.user!.username;
        _email = authState.user!.email!;

        // Get user profile - in a real app you'd fetch from backend
        // For demo, we'll create mock profile data
        _userProfile = UserProfile(
          height: 175,
          weight: 70,
          birthYear: 1990,
          age: DateTime.now().year - 1990,
          gender: "Male",
          mealFrequency: "3 meals per day",
          goal: "Maintain Weight",
          targetWeight: 70,
          activityLevel:
              "Moderately Active (moderate exercise/sports 3-5 days/week)",
          dietType: "Everything (no restrictions)",
          allergies: ["Nuts"],
          preferredLocalFoods: ["Ugali", "Rice", "Beans", "Fish"],
          healthConditions: ["None"],
        );
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _editProfile() {
    // Navigate to profile edit page
    context.go(
      '/profile/edit',
      extra: {'userId': 'current_user', 'username': _username},
    );
  }

  void _goToSettings() {
    context.go('/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Navigate to the SettingsPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Profile Page Content Goes Here',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
