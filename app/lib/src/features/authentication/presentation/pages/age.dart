import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

class AgeSelection extends StatefulWidget {
  const AgeSelection({super.key});

  @override
  State<AgeSelection> createState() => _AgeSelectionState();
}

class _AgeSelectionState extends State<AgeSelection> {
  DateTime _selectedDate = DateTime.now().subtract(Duration(days: 365 * 18));
  bool _isLoading = false;

  Future<void> _saveUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Calculate age
      final now = DateTime.now();
      final age = now.year - _selectedDate.year -
          (now.month > _selectedDate.month ||
                  (now.month == _selectedDate.month &&
                      now.day >= _selectedDate.day)
              ? 0
              : 1);

      // Save user data
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'dateOfBirth': _selectedDate,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Navigate to BMI page
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/bmi_page');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Lishe',
          style: TextStyle(
            fontSize: 40,
            color: Color.fromARGB(255, 13, 95, 133),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'When were you born?',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'This will be used to calibrate your custom plan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 48),
                Center(
                  child: DatePickerWidget(
                    looping: false,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    initialDate: _selectedDate,
                    dateFormat: "dd-MMMM-yyyy",
                    onChange: (DateTime newDate, _) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                    pickerTheme: DateTimePickerTheme(
                      backgroundColor: Colors.transparent,
                      itemTextStyle:
                          TextStyle(color: Colors.black87, fontSize: 19),
                    ),
                  ),
                ),
                SizedBox(height: 48),
                Center(
                  child: SizedBox(
                    width: 375,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _saveUserData,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 13, 95, 133),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
