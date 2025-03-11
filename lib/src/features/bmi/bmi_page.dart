import 'package:flutter/material.dart';
import 'package:lishe_app2/src/features/bmi/widgets/card.dart';
import 'package:numberpicker/numberpicker.dart';

import '../authentication/presentation/pages/select_chip.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _InputPageState();
}

class _InputPageState extends State<BmiPage> {
  bool isMaleSelected = false;
  int height = 170;
  int weight = 60;
  int age = 18;
  void ageIncrement() {
    setState(() {
      age++;
    });
  }

  void ageDecrement() {
    setState(() {
      age--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(
            'This will be used to calibrate your custom plan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMaleSelected = true;
                  });
                },
                child: AppCard(
                  borderSide: isMaleSelected
                      ? const BorderSide(color: Colors.white70, width: 3)
                      : BorderSide.none,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.male,
                        color: Colors.orange,
                        size: 65, // Increased icon size
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Male',
                        style: isMaleSelected
                            ? textTheme.bodySmall?.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold)
                            : textTheme.labelSmall?.copyWith(
                                fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMaleSelected = false;
                  });
                },
                child: AppCard(
                    borderSide: isMaleSelected == false
                        ? const BorderSide(color: Colors.white70, width: 3)
                        : BorderSide.none,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.female,
                          color: Colors.pinkAccent,
                          size: 65, // Increased icon size
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Female',
                          style: isMaleSelected == false
                              ? textTheme.bodySmall?.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.bold)
                              : textTheme.labelSmall?.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ],
                    )),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AppCard(
                width: 370,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Height (in cm)',
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    NumberPicker(
                        minValue: 120,
                        maxValue: 220,
                        value: height,
                        selectedTextStyle:
                            const TextStyle(color: Colors.white, fontSize: 24),
                        textStyle: const TextStyle(
                            color: Colors.white54, fontSize: 16),
                        axis: Axis.horizontal,
                        itemCount: 5,
                        itemWidth: 60,
                        onChanged: (newValue) {
                          setState(() {
                            height = newValue;
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                          5,
                          (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 29),
                                height: index == 2 ? 30 : 20,
                                width: 2,
                                color:
                                    index == 2 ? Colors.white : Colors.white54,
                              )),
                    )
                  ],
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppCard(
                  child: Column(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Weight(kg)',
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 80,
                    width: 130,
                    decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.18),
                        border: Border.all(
                            width: 2,
                            color: Colors.grey.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(30)),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        const Positioned(
                          bottom: 60,
                          child: RotatedBox(
                            quarterTurns: 45,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 30,
                            ),
                          ),
                        ),
                        Center(
                          child: NumberPicker(
                              minValue: 10,
                              maxValue: 150,
                              value: weight,
                              itemWidth: 40,
                              selectedTextStyle: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                              textStyle: const TextStyle(
                                  color: Colors.white54, fontSize: 16),
                              axis: Axis.horizontal,
                              onChanged: (newValue) {
                                setState(() {
                                  weight = newValue;
                                });
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              )),
              const SizedBox(
                width: 10,
              ),
              AppCard(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Age',
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          ageDecrement();
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.white54, width: 3)),
                          child: Center(
                            child: Text(
                              '-',
                              style: textTheme.labelSmall,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '$age',
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ageIncrement();
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Colors.white54, width: 3)),
                          child: Center(
                            child: Text(
                              '+',
                              style: textTheme.labelSmall,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
            ],
          ),
          const SizedBox(
            height: 45,
          ),
          Center(
            child: SizedBox(
              width: 375,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HobbySelector()));
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
    );
  }
}
