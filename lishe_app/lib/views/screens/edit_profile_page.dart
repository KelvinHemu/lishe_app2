import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_profile_model.dart';
import '../../providers/user_profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final String userId;
  final String? username;

  const EditProfilePage({super.key, required this.userId, this.username});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _targetWeightController;
  int? _birthYear;
  String? _selectedGender;
  String? _selectedMealFrequency;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Prefer not to say'];
  final List<String> _mealFrequencyOptions = [
    '3 meals per day',
    '3 meals + snacks',
    '5-6 smaller meals',
    'Intermittent Fasting',
  ];

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _targetWeightController = TextEditingController();

    // Load user profile data
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profileState = ref.read(userProfileProvider);

    if (profileState is AsyncData<UserProfile?> && profileState.value != null) {
      final profile = profileState.value!;

      setState(() {
        if (profile.height != null) {
          _heightController.text = profile.height.toString();
        }
        if (profile.weight != null) {
          _weightController.text = profile.weight.toString();
        }
        if (profile.targetWeight != null) {
          _targetWeightController.text = profile.targetWeight.toString();
        }
        _birthYear = profile.birthYear;
        _selectedGender = profile.gender;
        _selectedMealFrequency = profile.mealFrequency;
      });
    } else {
      // Load profile from provider
      ref.read(userProfileProvider.notifier).loadUserProfile(widget.userId);
    }
  }

  void _showYearPicker() {
    final int currentYear = DateTime.now().year;
    final int startYear = currentYear - 100;
    final int initialYear = _birthYear ?? (currentYear - 25);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Birth Year',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: YearPicker(
                  firstDate: DateTime(startYear),
                  lastDate: DateTime(currentYear),
                  selectedDate: DateTime(initialYear),
                  onChanged: (DateTime dateTime) {
                    setState(() {
                      _birthYear = dateTime.year;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create updated profile object
        final updateData = {
          'height':
              _heightController.text.isNotEmpty
                  ? double.parse(_heightController.text)
                  : null,
          'weight':
              _weightController.text.isNotEmpty
                  ? double.parse(_weightController.text)
                  : null,
          'birthYear': _birthYear,
          'age': _birthYear != null ? DateTime.now().year - _birthYear! : null,
          'gender': _selectedGender,
          'mealFrequency': _selectedMealFrequency,
          'targetWeight':
              _targetWeightController.text.isNotEmpty
                  ? double.parse(_targetWeightController.text)
                  : null,
        };

        // Get current profile data
        final profileState = ref.read(userProfileProvider);
        UserProfile updatedProfile;

        if (profileState is AsyncData<UserProfile?> &&
            profileState.value != null) {
          // Update existing profile
          updatedProfile = profileState.value!.copyWith(
            height: updateData['height'] as double?,
            weight: updateData['weight'] as double?,
            birthYear: updateData['birthYear'] as int?,
            age: updateData['age'] as int?,
            gender: updateData['gender'] as String?,
            mealFrequency: updateData['mealFrequency'] as String?,
            targetWeight: updateData['targetWeight'] as double?,
          );
        } else {
          // Create new profile
          updatedProfile = UserProfile(
            height: updateData['height'] as double?,
            weight: updateData['weight'] as double?,
            birthYear: updateData['birthYear'] as int?,
            age: updateData['age'] as int?,
            gender: updateData['gender'] as String?,
            mealFrequency: updateData['mealFrequency'] as String?,
            targetWeight: updateData['targetWeight'] as double?,
            activityLevel: null,
            goal: null,
            dietType: null,
            allergies: const [],
            preferredLocalFoods: const [],
            healthConditions: const [],
          );
        }

        // Update profile in provider
        await ref
            .read(userProfileProvider.notifier)
            .updateUserProfile(updatedProfile);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          context.go('/profile');
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/profile'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        // Implement photo upload
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Photo upload not implemented in this demo',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: const Text('Change Photo'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Basic info form
              const Text(
                'Basic Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Height
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final height = double.tryParse(value);
                    if (height == null || height <= 0) {
                      return 'Please enter a valid height';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.monitor_weight_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return 'Please enter a valid weight';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Birth Year
              GestureDetector(
                onTap: _showYearPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _birthYear != null
                              ? 'Birth Year: $_birthYear'
                              : 'Select Birth Year',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                _birthYear != null
                                    ? Colors.black
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gender
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items:
                    _genderOptions.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Meal frequency
              DropdownButtonFormField<String>(
                value: _selectedMealFrequency,
                decoration: const InputDecoration(
                  labelText: 'Meal Frequency',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.access_time),
                ),
                items:
                    _mealFrequencyOptions.map((frequency) {
                      return DropdownMenuItem<String>(
                        value: frequency,
                        child: Text(frequency),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMealFrequency = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Target weight
              TextFormField(
                controller: _targetWeightController,
                decoration: const InputDecoration(
                  labelText: 'Target Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return 'Please enter a valid weight';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                          : const Text(
                            'Save Changes',
                            style: TextStyle(
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
    );
  }
}
