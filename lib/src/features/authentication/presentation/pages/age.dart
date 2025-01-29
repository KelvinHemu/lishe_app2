import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:lishe_app2/src/features/bmi/bmi_page.dart';

class AgeSelection extends StatelessWidget {
  const AgeSelection({super.key});

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'When were you born',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'This will be used to calibrate your custom plan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),

              SizedBox(height: 163),

              //date select from flutter_holo_date_picker
              Center(
                child: DatePickerWidget(
                  looping: false,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialDate:
                      DateTime.now().subtract(Duration(days: 365 * 18)),
                  dateFormat: "dd-MMMM-yyyy",
                  onChange: (DateTime newDate, _) {
                    // Handle date selection here
                  },
                  pickerTheme: DateTimePickerTheme(
                    backgroundColor: const Color.fromARGB(0, 242, 236, 236),
                    itemTextStyle: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 19),
                  ),
                ),
              ),
              SizedBox(height: 250),
              Center(
                child: SizedBox(
                  width: 375,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BmiPage()));
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
      ),
    );
  }
}
