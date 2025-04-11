import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/food_item.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class FoodNutritionCard extends StatelessWidget {
  final FoodItem foodItem;

  const FoodNutritionCard({
    super.key,
    required this.foodItem,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print to check the foodUrl
    print('Food URL for ${foodItem.foodName}: ${foodItem.foodUrl}');

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: foodItem.getImageUrl() != null
                  ? FutureBuilder<ImageProvider>(
                      future: _loadImage(foodItem.getImageUrl()!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          print('Error loading image: ${snapshot.error}');
                          return const Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return Image(
                            image: snapshot.data!,
                            fit: BoxFit.cover,
                          );
                        }
                        return const Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Name
                Text(
                  foodItem.foodName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (foodItem.brandName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    foodItem.brandName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                // Nutrition Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNutrientInfo(
                        'Calories', foodItem.calories, 'kcal', Colors.red),
                    _buildNutrientInfo(
                        'Protein', foodItem.protein, 'g', Colors.green),
                    _buildNutrientInfo(
                        'Carbs', foodItem.carbs, 'g', Colors.blue),
                    _buildNutrientInfo('Fat', foodItem.fat, 'g', Colors.amber),
                  ],
                ),
                const SizedBox(height: 8),
                // Serving Size
                Text(
                  'Per ${foodItem.servingSize ?? ""} ${foodItem.servingUnit}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(
      String label, double? value, String unit, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value != null ? '${value.toStringAsFixed(1)} $unit' : '-- $unit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<ImageProvider> _loadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return MemoryImage(response.bodyBytes);
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading image: $e');
      rethrow;
    }
  }
}
