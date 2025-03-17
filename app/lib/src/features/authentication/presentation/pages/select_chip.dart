import 'package:flutter/material.dart';

const Color kActiveColor = Colors.blue;

class HobbySelector extends StatefulWidget {
  const HobbySelector({super.key});

  @override
  State<HobbySelector> createState() => _HobbySelectorState();
}

class _HobbySelectorState extends State<HobbySelector> {
  final List<String> foodsRecipesExerciseList = [
    'Ugali',
    'Nyama Choma',
    'Pilau',
    'Kachumbari',
    'Chapati',
    'Mandazi',
    'Matoke',
    'Chai ya Tangawizi',
    'Juisi ya Miwa',
    'Vitumbua',
    'Mishikaki',
    'Yoga',
    'Mshikaki',
    'Dagaa',
    'Mboga za Majani',
    'Mbaazi za Nazi',
    'Mchicha',
    'Makande',
    'Samaki wa Kupaka',
    'Ngoma za Asili',
    'Running',
    'Theater Performances',
    'Baking',
    'Gardening',
    'Cooking',
    'Video Games',
    'Aerobics',
    'Healthy Snacks',
    'Samosa',
    'Uji wa Lishe',
    'Bike Riding',
    'Swimming',
    'Traditional Dancing',
    'Hiking',
    'Reading',
    'Mtori',
    'Walking',
  ];
  List<String> selectedHobby = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Lishe',
          style: TextStyle(
            fontSize: 40,
            color: const Color.fromARGB(255, 13, 95, 133),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select up to 10 Foods, Recipes, and Exercises you enjoy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: foodsRecipesExerciseList.map((hobby) {
                    bool isSelected = selectedHobby.contains(hobby);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!selectedHobby.contains(hobby) &&
                              selectedHobby.length < 10) {
                            selectedHobby.add(hobby);
                          } else {
                            selectedHobby.remove(hobby);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? kActiveColor.withValues(alpha: .2)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? kActiveColor : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          hobby,
                          style: TextStyle(
                            color: isSelected ? kActiveColor : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 375,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HobbySelector()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color.fromARGB(255, 13, 95, 133),
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
    );
  }
}
