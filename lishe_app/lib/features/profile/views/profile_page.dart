import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lishe_app/features/setting/views/settings_page.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample user data
  final user = {
    'name': 'John Doe',
    'email': 'john@lisheapp.co.tz',
    'location': 'Dar es Salaam, Tanzania',
    'age': 32,
    'height': 1.65,
    'weight': 75,
    'goals': 'Weight management',
    'memberSince': 'March 2023',
    'streak': 14,
    'level': 'Gold Member',
    'points': 200,
    'nextLevel': 3000,
    'image':
        'https://img.freepik.com/free-photo/happy-successful-businessman-posing-outside_74855-2004.jpg?ga=GA1.1.925693881.1743051736&semt=ais_hybrid',
    'waterIntake': 5.2,
    'calories': 1850,
    'nutritionScore': 85,
  };

  bool _showFullStats = false;
  int _selectedTab = 0; // 0 for weekly, 1 for monthly

  @override
  Widget build(BuildContext context) {
    final levelPercentage =
        (user['points'] as int) / (user['nextLevel'] as int);
    final waterPercentage = (user['waterIntake'] as double) / 8.0; // 8L is goal

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with flexible space
          SliverAppBar(
            expandedHeight: 40.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color.fromARGB(255, 255, 254, 254),
            elevation: 1,
            centerTitle: true,
            title: Text(
              "My Profile",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ],
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header with Image and Stats
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image with Level Badge
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 2),
                              borderRadius: BorderRadius.circular(80),
                              image: DecorationImage(
                                image: NetworkImage(user['image']! as String),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: GestureDetector(
                                onTap: () => context.go('/profile/edit'),
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),

                      // User Info and Stats
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'] as String,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user['email'] as String,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Level Progress
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${user['points']} XP',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${user['nextLevel']} XP for next level',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: levelPercentage,
                                  backgroundColor: Colors.grey[200],
                                  color: Colors.amber,
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Quick Stats Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildQuickStatCard(
                          Icons.local_fire_department,
                          'Calories',
                          '${user['calories']}',
                          'kcal',
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickStatCard(
                          Icons.water,
                          'Water',
                          '${user['waterIntake']}',
                          'L',
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Personal Details Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDetailItem(
                              Icons.location_on,
                              'Location',
                              user['location'] as String,
                              Colors.blue,
                            ),
                            const Divider(height: 24, thickness: 0.5),
                            _buildDetailItem(
                              Icons.cake,
                              'Age',
                              '${user['age']} years',
                              Colors.pink,
                            ),
                            const Divider(height: 24, thickness: 0.5),
                            _buildDetailItem(
                              Icons.flag,
                              'Goals',
                              user['goals'] as String,
                              Colors.purple,
                            ),
                            const Divider(height: 24, thickness: 0.5),
                            _buildDetailItem(
                              Icons.calendar_today,
                              'Member Since',
                              user['memberSince'] as String,
                              Colors.amber,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Stats Section with Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Nutrition Stats',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTab = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _selectedTab == 0
                                        ? Colors.blue[50]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Weekly',
                                style: TextStyle(
                                  color:
                                      _selectedTab == 0
                                          ? Colors.blue
                                          : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTab = 1;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _selectedTab == 1
                                        ? Colors.blue[50]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Monthly',
                                style: TextStyle(
                                  color:
                                      _selectedTab == 1
                                          ? Colors.blue
                                          : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Nutrition Score
                            Row(
                              children: [
                                CircularPercentIndicator(
                                  radius: 30.0,
                                  lineWidth: 6.0,
                                  percent:
                                      (user['nutritionScore'] as int) / 100,
                                  center: Text(
                                    '${user['nutritionScore']}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  progressColor: Colors.green,
                                  backgroundColor: Colors.green[100]!,
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nutrition Score',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Based on your meal balance and variety',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Macro Breakdown
                            const Text(
                              'Macro Breakdown',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildMacroIndicator(
                                  'Carbs',
                                  45,
                                  Colors.orange,
                                ),
                                _buildMacroIndicator(
                                  'Protein',
                                  30,
                                  Colors.green,
                                ),
                                _buildMacroIndicator('Fats', 25, Colors.purple),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Toggle for full stats
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showFullStats = !_showFullStats;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _showFullStats
                                          ? 'Show Less'
                                          : 'Show Full Stats',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      _showFullStats
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Expanded stats (shown when toggled)
                            if (_showFullStats) ...[
                              const Divider(height: 24, thickness: 0.5),
                              _buildFullStatItem(
                                'Fiber Intake',
                                '22g',
                                'of 30g goal',
                              ),
                              const Divider(height: 24, thickness: 0.5),
                              _buildFullStatItem(
                                'Sugar Intake',
                                '18g',
                                'of 25g limit',
                              ),
                              const Divider(height: 24, thickness: 0.5),
                              _buildFullStatItem(
                                'Vitamins',
                                '87%',
                                'of daily recommended',
                              ),
                              const Divider(height: 24, thickness: 0.5),
                              _buildFullStatItem(
                                'Meal Consistency',
                                '92%',
                                'on-time meals',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Water Intake Progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Water Intake',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.water,
                                  color: Colors.blue[300],
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user['waterIntake']}L / 8L',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Daily water goal',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                CircularPercentIndicator(
                                  radius: 30.0,
                                  lineWidth: 6.0,
                                  percent: waterPercentage,
                                  center: Text(
                                    '${(waterPercentage * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  progressColor: Colors.blue,
                                  backgroundColor: Colors.lightBlue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: waterPercentage,
                              backgroundColor: Colors.blue[100],
                              color: Colors.blue,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildWaterTime('Morning', '2.1L', true),
                                _buildWaterTime('Afternoon', '1.8L', false),
                                _buildWaterTime('Evening', '1.3L', false),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Achievements Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Achievements',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildAchievementBadge(
                              'Meal Streak',
                              '7 days',
                              Icons.local_fire_department,
                              Colors.orange,
                            ),
                            const SizedBox(width: 12),
                            _buildAchievementBadge(
                              'Healthy Choice',
                              '10 meals',
                              Icons.eco,
                              Colors.green,
                            ),
                            const SizedBox(width: 12),
                            _buildAchievementBadge(
                              'Water Master',
                              '5 days',
                              Icons.water,
                              Colors.blue,
                            ),
                            const SizedBox(width: 12),
                            _buildAchievementBadge(
                              'Early Bird',
                              '7 days',
                              Icons.wb_sunny,
                              Colors.amber,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
    IconData icon,
    String title,
    String value,
    String unit,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            '$value.$unit',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroIndicator(String label, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: color.withOpacity(0.2),
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$label $value%',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullStatItem(String title, String value, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildWaterTime(String time, String amount, bool isActive) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
