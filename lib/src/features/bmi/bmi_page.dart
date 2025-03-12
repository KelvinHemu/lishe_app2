import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> with SingleTickerProviderStateMixin {
  bool isMaleSelected = true;
  double height = 170;
  double weight = 60;
  double age = 25;
  double? bmi;
  String bmiCategory = '';
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserBMIData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserBMIData() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            height = doc.data()?['height']?.toDouble() ?? 170;
            weight = doc.data()?['weight']?.toDouble() ?? 60;
            bmi = doc.data()?['bmi']?.toDouble();
            isMaleSelected = doc.data()?['gender'] == 'male';
            if (bmi != null) _updateBMICategory();
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateBMICategory() {
    if (bmi == null) return;
    if (bmi! < 18.5) {
      bmiCategory = 'Underweight';
    } else if (bmi! >= 18.5 && bmi! < 25) {
      bmiCategory = 'Normal';
    } else if (bmi! >= 25 && bmi! < 30) {
      bmiCategory = 'Overweight';
    } else {
      bmiCategory = 'Obese';
    }
  }

  Color _getBMICategoryColor() {
    if (bmi == null) return Colors.grey;
    if (bmi! < 18.5) return Colors.blue;
    if (bmi! >= 18.5 && bmi! < 25) return Colors.green;
    if (bmi! >= 25 && bmi! < 30) return Colors.orange;
    return Colors.red;
  }

  Future<void> _calculateAndSaveBMI() async {
    setState(() => _isLoading = true);
    try {
      final calculatedBMI = weight / ((height / 100) * (height / 100));
      setState(() {
        bmi = double.parse(calculatedBMI.toStringAsFixed(1));
        _updateBMICategory();
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'bmi': bmi,
          'height': height,
          'weight': weight,
          'gender': isMaleSelected ? 'male' : 'female',
          'bmiCategory': bmiCategory,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error calculating BMI: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'BMI Calculator',
          style: TextStyle(
            color: Color.fromARGB(255, 13, 95, 133),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 13, 95, 133)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculate Your BMI',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Body Mass Index (BMI) is a measure of body fat based on height and weight.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Gender Selection with gradient background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 13, 95, 133).withOpacity(0.05),
                            Color.fromARGB(255, 13, 95, 133).withOpacity(0.1),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isMaleSelected = true),
                              child: _SelectionCard(
                                isSelected: isMaleSelected,
                                icon: Icons.male,
                                label: 'Male',
                                color: Color.fromARGB(255, 13, 95, 133),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isMaleSelected = false),
                              child: _SelectionCard(
                                isSelected: !isMaleSelected,
                                icon: Icons.female,
                                label: 'Female',
                                color: Color.fromARGB(255, 13, 95, 133),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Height Slider with gradient background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 13, 95, 133).withOpacity(0.05),
                            Color.fromARGB(255, 13, 95, 133).withOpacity(0.1),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Height',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    height.toStringAsFixed(0),
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 13, 95, 133),
                                    ),
                                  ),
                                  Text(
                                    ' cm',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color.fromARGB(255, 13, 95, 133),
                              inactiveTrackColor: Colors.grey[300],
                              thumbColor: Color.fromARGB(255, 13, 95, 133),
                              overlayColor: Color.fromARGB(255, 13, 95, 133).withOpacity(0.2),
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 28),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: height,
                              min: 120,
                              max: 220,
                              onChanged: (value) => setState(() => height = value),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('120 cm', style: TextStyle(color: Colors.grey[600])),
                              Text('220 cm', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Weight and Age with gradient backgrounds
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 13, 95, 133).withOpacity(0.05),
                                  Color.fromARGB(255, 13, 95, 133).withOpacity(0.1),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: _AdjustableCard(
                              label: 'Weight',
                              value: weight.toStringAsFixed(1),
                              unit: 'kg',
                              onIncrement: () => setState(() => weight += 0.5),
                              onDecrement: () => setState(() => weight -= 0.5),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromARGB(255, 13, 95, 133).withOpacity(0.05),
                                  Color.fromARGB(255, 13, 95, 133).withOpacity(0.1),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: _AdjustableCard(
                              label: 'Age',
                              value: age.toStringAsFixed(0),
                              unit: 'years',
                              onIncrement: () => setState(() => age += 1),
                              onDecrement: () => setState(() => age -= 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    // BMI Result with enhanced design
                    if (bmi != null)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _getBMICategoryColor().withOpacity(0.8),
                                _getBMICategoryColor().withOpacity(0.6),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _getBMICategoryColor().withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                'Your BMI',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                bmi!.toString(),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                bmiCategory,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                _getBMIMessage(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 24),
                    // Calculate Button with gradient
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromARGB(255, 13, 95, 133),
                            Color.fromARGB(255, 13, 95, 133).withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 13, 95, 133).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _calculateAndSaveBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          bmi == null ? 'Calculate BMI' : 'Update BMI',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  String _getBMIMessage() {
    if (bmi == null) return '';
    if (bmi! < 18.5) {
      return 'You are underweight. Consider consulting with a healthcare provider about a healthy weight gain plan.';
    } else if (bmi! >= 18.5 && bmi! < 25) {
      return 'Congratulations! You are at a healthy weight. Keep maintaining your healthy lifestyle.';
    } else if (bmi! >= 25 && bmi! < 30) {
      return 'You are overweight. Consider adopting a balanced diet and regular exercise routine.';
    } else {
      return 'You are in the obese range. It\'s recommended to consult with a healthcare provider for personalized advice.';
    }
  }
}

class _SelectionCard extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final String label;
  final Color color;

  const _SelectionCard({
    required this.isSelected,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? color : Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdjustableCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _AdjustableCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 13, 95, 133),
                  ),
                ),
                Text(
                  ' $unit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CircularButton(
                  icon: Icons.remove,
                  onPressed: onDecrement,
                ),
                _CircularButton(
                  icon: Icons.add,
                  onPressed: onIncrement,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircularButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 13, 95, 133).withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: Color.fromARGB(255, 13, 95, 133),
        ),
      ),
    );
  }
}
