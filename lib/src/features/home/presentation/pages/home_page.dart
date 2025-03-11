import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lishe',
          style: TextStyle(
            fontSize: 40,
            color: Color.fromARGB(255, 13, 95, 133),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login_page');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Color.fromARGB(255, 13, 95, 133),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    title: 'BMI Calculator',
                    icon: Icons.monitor_weight,
                    color: Colors.blue,
                    onTap: () => Navigator.pushNamed(context, '/bmi_page'),
                  ),
                  _DashboardCard(
                    title: 'Food Tracking',
                    icon: Icons.restaurant_menu,
                    color: Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/food_tracking'),
                  ),
                  _DashboardCard(
                    title: 'Nutrition Info',
                    icon: Icons.info_outline,
                    color: Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/nutrition_info'),
                  ),
                  _DashboardCard(
                    title: 'Preferences',
                    icon: Icons.favorite,
                    color: Colors.red,
                    onTap: () => Navigator.pushNamed(context, '/select_chip'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Stats',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            label: 'BMI',
                            value: '22.5',
                            icon: Icons.monitor_weight,
                          ),
                          _StatItem(
                            label: 'Calories Today',
                            value: '1,850',
                            icon: Icons.local_fire_department,
                          ),
                          _StatItem(
                            label: 'Water',
                            value: '2.5L',
                            icon: Icons.water_drop,
                          ),
                        ],
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
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Color.fromARGB(255, 13, 95, 133)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
} 