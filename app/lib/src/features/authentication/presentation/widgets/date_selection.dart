import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class DateSelection extends StatefulWidget {
  const DateSelection({super.key, required this.title});

  final String title;

  @override
  State<DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends State<DateSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 30,
            top: 60,
            child: TimePickerSpinnerPopUp(
              mode: CupertinoDatePickerMode.monthYear,
              initTime: DateTime.now(),
              minTime: DateTime.now().subtract(const Duration(days: 10)),
              maxTime: DateTime.now().add(const Duration(days: 10)),
              barrierColor: Colors.black12, //Barrier Color when pop up show
              minuteInterval: 1,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              cancelText: 'Cancel',
              confirmText: 'OK',
              enable: true,
              radius: 10,
              pressType: PressType.singlePress,
              timeFormat: 'dd/MM/yyyy',
              // Customize your time widget
              // timeWidgetBuilder: (dateTime) {},
              locale: const Locale('vi'),
              onChange: (dateTime) {
                // Implement your logic with select dateTime
              },
            ),
          ),
        ],
      ),
    );
  }
}
