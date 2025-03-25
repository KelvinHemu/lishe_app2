import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_profile_model.dart';

class ProfilePage extends ConsumerStatefulWidget {
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
        _email = authState.user!.email;

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
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black87),
            onPressed: _goToSettings,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User profile header
                    _buildProfileHeader(),
                    const SizedBox(height: 24),

                    // Nutrition profile card
                    if (_userProfile != null) _buildNutritionProfileCard(),
                    const SizedBox(height: 16),

                    // Health goals card
                    if (_userProfile != null) _buildHealthGoalsCard(),
                    const SizedBox(height: 16),

                    // Dietary preferences card
                    if (_userProfile != null) _buildDietaryPreferencesCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          // Profile picture
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: const Icon(Icons.person, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Username
          Text(
            _username,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          // Email
          Text(_email, style: TextStyle(fontSize: 16, color: Colors.grey[600])),

          const SizedBox(height: 16),

          // Edit profile button
          OutlinedButton.icon(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Profile'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person_outline, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Basic Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Height', '${_userProfile!.height} cm'),
            _buildInfoRow('Weight', '${_userProfile!.weight} kg'),
            _buildInfoRow('Age', '${_userProfile!.age} years'),
            _buildInfoRow('Gender', _userProfile!.gender ?? 'Not specified'),
            _buildInfoRow(
              'Meal Frequency',
              _userProfile!.mealFrequency ?? 'Not specified',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthGoalsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emoji_events_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Health Goals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Goal', _userProfile!.goal ?? 'Not specified'),
            _buildInfoRow('Target Weight', '${_userProfile!.targetWeight} kg'),
            _buildInfoRow(
              'Activity Level',
              _userProfile!.activityLevel ?? 'Not specified',
            ),
            _buildInfoRow(
              'Health Conditions',
              _userProfile!.healthConditions.isEmpty
                  ? 'None'
                  : _userProfile!.healthConditions.join(', '),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietaryPreferencesCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.restaurant_menu_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Dietary Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Diet Type',
              _userProfile!.dietType ?? 'Not specified',
            ),
            _buildInfoRow(
              'Allergies',
              _userProfile!.allergies.isEmpty
                  ? 'None'
                  : _userProfile!.allergies.join(', '),
            ),
            _buildInfoRow(
              'Preferred Foods',
              _userProfile!.preferredLocalFoods.isEmpty
                  ? 'None'
                  : _userProfile!.preferredLocalFoods.join(', '),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
