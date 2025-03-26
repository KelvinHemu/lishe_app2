import 'package:flutter/material.dart';

class RatingStarsWidget extends StatefulWidget {
  final double rating;
  final double size;
  final bool showRatingValue;
  final bool isInteractive;
  final Function(double)? onRatingChanged;

  const RatingStarsWidget({
    super.key,
    required this.rating,
    this.size = 24,
    this.showRatingValue = false,
    this.isInteractive = false,
    this.onRatingChanged,
  });

  @override
  State<RatingStarsWidget> createState() => _RatingStarsWidgetState();
}

class _RatingStarsWidgetState extends State<RatingStarsWidget> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    final int fullStars = _currentRating.floor();
    final bool hasHalfStar = _currentRating - fullStars >= 0.5;
    final int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // We'll use a Stack to allow for horizontal dragging across stars
        Stack(
          children: [
            // The visible star row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  fullStars,
                  (index) => _buildStar(index + 1, Icons.star),
                ),
                if (hasHalfStar) _buildStar(fullStars + 1, Icons.star_half),
                ...List.generate(
                  emptyStars,
                  (index) => _buildStar(
                    fullStars + (hasHalfStar ? 1 : 0) + index + 1,
                    Icons.star_outline,
                  ),
                ),
                if (widget.showRatingValue) ...[
                  const SizedBox(width: 4),
                  Text(
                    _currentRating.toStringAsFixed(1),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.size * 0.8,
                    ),
                  ),
                ],
              ],
            ),
            // Invisible slider for smooth dragging experience
            if (widget.isInteractive)
              Positioned.fill(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (!widget.isInteractive) return;

                    final double starWidth =
                        widget.size + 4; // star + small padding

                    // Calculate position within the row
                    final double position = details.localPosition.dx;

                    // Convert to star rating (1-5)
                    double newRating = (position / starWidth).clamp(0.5, 5.0);

                    // Round to nearest 0.5
                    newRating = (newRating * 2).round() / 2;

                    if (newRating != _currentRating) {
                      setState(() {
                        _currentRating = newRating;
                      });

                      if (widget.onRatingChanged != null) {
                        widget.onRatingChanged!(newRating);
                      }
                    }
                  },
                  onHorizontalDragEnd: (_) {
                    // Rating has been selected via drag
                    // Parent will handle this through onRatingChanged callback
                  },
                  child: Container(color: Colors.transparent),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStar(int starNumber, IconData iconData) {
    return GestureDetector(
      onTap:
          widget.isInteractive
              ? () {
                setState(() {
                  _currentRating = starNumber.toDouble();
                });
                if (widget.onRatingChanged != null) {
                  widget.onRatingChanged!(_currentRating);
                }
              }
              : null,
      child: Icon(iconData, color: Colors.amber.shade600, size: widget.size),
    );
  }
}
