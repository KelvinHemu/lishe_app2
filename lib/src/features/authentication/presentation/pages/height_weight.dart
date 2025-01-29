import 'package:flutter/material.dart';

void main() {
  runApp(HeightWeight());
}

class HeightWeight extends StatefulWidget {
  const HeightWeight({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HeightWeightState createState() => _HeightWeightState();
}

class _HeightWeightState extends State<HeightWeight> {
  int _height = 174;
  int _weight = 60;
  int _age = 18;
  String _gender = 'Male';

  void _incrementHeight() {
    setState(() {
      _height++;
    });
  }

  void _decrementHeight() {
    setState(() {
      _height--;
    });
  }

  void _incrementWeight() {
    setState(() {
      _weight++;
    });
  }

  void _decrementWeight() {
    setState(() {
      _weight--;
    });
  }

  void _incrementAge() {
    setState(() {
      _age++;
    });
  }

  void _decrementAge() {
    setState(() {
      _age--;
    });
  }

  void _toggleGender() {
    setState(() {
      _gender = _gender == 'Male' ? 'Female' : 'Male';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gender and Age',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gender and Age'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _toggleGender,
                    child: Icon(
                      _gender == 'Male' ? Icons.male : Icons.female,
                      size: 48,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(_gender, style: TextStyle(fontSize: 20)),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _decrementHeight,
                    child: Icon(Icons.remove_circle, size: 32),
                  ),
                  SizedBox(width: 16),
                  Text('$_height', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: _incrementHeight,
                    child: Icon(Icons.add_circle, size: 32),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Height (in cm)', style: TextStyle(fontSize: 16)),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _decrementWeight,
                    child: Icon(Icons.remove_circle, size: 32),
                  ),
                  SizedBox(width: 16),
                  Text('$_weight', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: _incrementWeight,
                    child: Icon(Icons.add_circle, size: 32),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Weight', style: TextStyle(fontSize: 16)),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _decrementAge,
                    child: Icon(Icons.remove_circle, size: 32),
                  ),
                  SizedBox(width: 16),
                  Text('$_age', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: _incrementAge,
                    child: Icon(Icons.add_circle, size: 32),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Age', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
