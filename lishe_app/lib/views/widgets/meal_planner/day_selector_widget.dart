import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySelectorWidget extends StatefulWidget {
  final List<DateTime> weekDates;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DaySelectorWidget({
    super.key,
    required this.weekDates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DaySelectorWidget> createState() => _DaySelectorWidgetState();
}

class _DaySelectorWidgetState extends State<DaySelectorWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Position the scroll to show today in the center
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(DaySelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _scrollToSelectedDate();
    }
  }

  void _scrollToSelectedDate() {
    final int todayIndex = widget.weekDates.indexWhere(
      (date) => DateUtils.isSameDay(date, DateTime.now()),
    );

    if (todayIndex != -1) {
      final double itemWidth = 45.0; // Update to match new width
      final double screenWidth = MediaQuery.of(context).size.width;
      final double offset =
          (todayIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50);

    return Container(
      height: 70, // Reduced from 100
      padding: const EdgeInsets.symmetric(vertical: 8), // Reduced from 10
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.weekDates.length,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ), // Added horizontal padding
        itemBuilder: (context, index) {
          final date = widget.weekDates[index];
          final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
          final isToday = DateUtils.isSameDay(date, DateTime.now());

          return _DayItem(
            date: date,
            isSelected: isSelected,
            isToday: isToday,
            primaryColor: primaryGreen,
            onTap: () => widget.onDateSelected(date),
          );
        },
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final Color primaryColor;
  final VoidCallback onTap;

  const _DayItem({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45, // Reduced from 60
        margin: const EdgeInsets.symmetric(horizontal: 4), // Reduced from 5
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8), // Reduced from 10
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4, // Reduced from 5
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            DateFormat('EEE').format(date),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14, // Reduced from 16
            ),
          ),
        ),
      ),
    );
  }
}
