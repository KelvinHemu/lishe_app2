import 'package:flutter/material.dart';
import '../models/nutritionist_model.dart';

class NutritionistProfileSimplified extends StatelessWidget {
  final Nutritionist nutritionist;

  const NutritionistProfileSimplified({
    Key? key,
    required this.nutritionist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nutritionist.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.network(
                nutritionist.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: nutritionist.accentColor.withOpacity(0.3),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Verification Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nutritionist.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: nutritionist.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      if (nutritionist.isVerified)
                        Icon(
                          Icons.verified,
                          color: nutritionist.accentColor,
                          size: 24,
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bio
                  Text(
                    nutritionist.bio,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Location
                  if (nutritionist.location.isNotEmpty)
                    _buildInfoItem(
                      Icons.location_on,
                      nutritionist.location,
                    ),

                  // Education
                  if (nutritionist.educationBackground != null)
                    _buildInfoItem(
                      Icons.school,
                      nutritionist.educationBackground!,
                    ),

                  // Experience
                  if (nutritionist.experienceYears != null)
                    _buildInfoItem(
                      Icons.work,
                      '${nutritionist.experienceYears} years of experience',
                    ),

                  const SizedBox(height: 24),

                  // Specializations
                  if (nutritionist.specializations != null &&
                      nutritionist.specializations!.isNotEmpty) ...[
                    Text(
                      'Specializations',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          nutritionist.specializations!.map((specialization) {
                        return Chip(
                          label: Text(specialization),
                          backgroundColor:
                              nutritionist.accentColor.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Contact Info
                  Text(
                    'Contact Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  if (nutritionist.email != null)
                    _buildInfoItem(Icons.email, nutritionist.email!),

                  if (nutritionist.phone != null)
                    _buildInfoItem(Icons.phone, nutritionist.phone!),

                  if (nutritionist.website != null)
                    _buildInfoItem(Icons.language, nutritionist.website!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
