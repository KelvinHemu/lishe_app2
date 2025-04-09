import 'package:flutter/material.dart';
import '../models/nutritionist_model.dart';

class NutritionistInfoWidget extends StatelessWidget {
  final Nutritionist nutritionist;
  final VoidCallback? onTap;
  final bool isCompact;

  const NutritionistInfoWidget({
    super.key,
    required this.nutritionist,
    this.onTap,
    this.isCompact = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            // Nutritionist profile image
            CircleAvatar(
              radius: isCompact ? 16 : 24,
              backgroundImage: NetworkImage(nutritionist.imageUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 8),

            // Nutritionist information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        nutritionist.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isCompact ? 14 : 16,
                        ),
                      ),
                      if (nutritionist.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          size: isCompact ? 14 : 16,
                          color: nutritionist.accentColor,
                        ),
                      ],
                    ],
                  ),
                  if (!isCompact || nutritionist.title.length < 30)
                    Text(
                      nutritionist.title,
                      style: TextStyle(
                        fontSize: isCompact ? 12 : 14,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
