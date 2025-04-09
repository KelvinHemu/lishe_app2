import 'package:flutter/material.dart';

class Viewfinder extends StatelessWidget {
  final double size;
  final double cornerLength;
  final double lineWidth;
  final Color color;

  const Viewfinder({
    super.key,
    this.size = 300.0,
    this.cornerLength = 40.0,
    this.lineWidth = 2.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Top Left Corner
          Positioned(
            top: 0,
            left: 0,
            child: _buildCorner(Axis.horizontal, Axis.vertical),
          ),

          // Top Right Corner
          Positioned(
            top: 0,
            right: 0,
            child: _buildCorner(Axis.horizontal, Axis.vertical, isStart: false),
          ),

          // Bottom Left Corner
          Positioned(
            bottom: 0,
            left: 0,
            child: _buildCorner(
              Axis.horizontal,
              Axis.vertical,
              isVerticalStart: false,
            ),
          ),

          // Bottom Right Corner
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildCorner(
              Axis.horizontal,
              Axis.vertical,
              isStart: false,
              isVerticalStart: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(
    Axis firstAxis,
    Axis secondAxis, {
    bool isStart = true,
    bool isVerticalStart = true,
  }) {
    return SizedBox(
      width: cornerLength,
      height: cornerLength,
      child: Stack(
        children: [
          // First line
          Align(
            alignment: isVerticalStart
                ? (isStart
                    ? AlignmentDirectional.topStart
                    : AlignmentDirectional.topEnd)
                : (isStart
                    ? AlignmentDirectional.bottomStart
                    : AlignmentDirectional.bottomEnd),
            child: Container(
              width: firstAxis == Axis.horizontal ? cornerLength : lineWidth,
              height: firstAxis == Axis.horizontal ? lineWidth : cornerLength,
              color: color,
            ),
          ),

          // Second line
          Align(
            alignment: isVerticalStart
                ? (isStart
                    ? AlignmentDirectional.topStart
                    : AlignmentDirectional.topEnd)
                : (isStart
                    ? AlignmentDirectional.bottomStart
                    : AlignmentDirectional.bottomEnd),
            child: Container(
              width: secondAxis == Axis.horizontal ? cornerLength : lineWidth,
              height: secondAxis == Axis.horizontal ? lineWidth : cornerLength,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage in a camera app:
class ViewfinderExample extends StatelessWidget {
  const ViewfinderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Viewfinder(
          size: 280,
          cornerLength: 40,
          lineWidth: 3,
          color: Colors.white,
        ),
      ),
    );
  }
}
