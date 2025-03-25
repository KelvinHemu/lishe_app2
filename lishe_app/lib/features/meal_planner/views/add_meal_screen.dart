import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/meal.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _recipeController = TextEditingController();

  // Image handling
  File? _imageFile;
  String? _imageUrl;
  final _imagePicker = ImagePicker();
  bool _isImageLoading = false;

  final List<String> _ingredients = [];
  String _newIngredient = '';
  final List<String> _selectedMealTypes = [];
  String _selectedDifficulty = 'Medium';
  String _selectedCategory = 'Main Course';
  double _weight = 250.0; // Default value
  int _servingSize = 1;
  bool _isSaving = false;

  // Dropdown options
  final List<String> _difficulties = [
    'Easy',
    'Medium',
    'Challenging',
    'Advanced',
  ];

  final List<String> _categories = [
    'Main Course',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Side Dish',
    'Snack',
    'Dessert',
    'Soup',
    'Salad',
    'Vegetarian',
    'High Protein',
    'Low Carb',
    'Low Calorie',
  ];

  final List<String> _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _preparationTimeController.dispose();
    _recipeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() {
      _isImageLoading = true;
    });

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
          _imageUrl = null; // Clear network image when local image is selected
        }
        _isImageLoading = false;
      });
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _addIngredient() {
    if (_newIngredient.isNotEmpty) {
      setState(() {
        _ingredients.add(_newIngredient);
        _newIngredient = '';
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _toggleMealType(String mealType) {
    setState(() {
      if (_selectedMealTypes.contains(mealType)) {
        _selectedMealTypes.remove(mealType);
      } else {
        _selectedMealTypes.add(mealType);
      }
    });
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) {
      // Show error toast
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // At least one meal type must be selected
    if (_selectedMealTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one meal type')),
      );
      return;
    }

    // At least one ingredient is required
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // In a real app, you would upload the image first and get a URL
      // For now, we'll just simulate a delay

      if (_imageFile != null) {
        // Simulate image upload
        await Future.delayed(const Duration(seconds: 1));
        // In a real app: _imageUrl = await uploadImageToStorage(_imageFile);
      }

      // Create a unique ID for the new meal
      final String newId = 'meal-${DateTime.now().millisecondsSinceEpoch}';

      // Create the meal object
      final meal = Meal(
        name: _nameController.text,
        calories: int.tryParse(_caloriesController.text) ?? 0,
        protein: double.tryParse(_proteinController.text) ?? 0,
        carbs: double.tryParse(_carbsController.text) ?? 0,
        fat: double.tryParse(_fatController.text) ?? 0,
        imageUrl:
            _imageUrl ??
            (_imageFile != null
                ? _imageFile!.path
                : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80'),
        ingredients: _ingredients,
        recipe: _recipeController.text,
        mealTypes: _selectedMealTypes,
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
        description: _descriptionController.text,
        weight: _weight.round(), // Convert double to int
        servingSize: _servingSize,
        preparationTime:
            _preparationTimeController.text.isEmpty
                ? '30 mins'
                : _preparationTimeController.text,
        id: '',
      );

      // Simulate saving to backend
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would save this meal to your storage/backend here
      // await mealService.addMeal(meal);

      setState(() {
        _isSaving = false;
      });

      if (!mounted) return;

      // Show success and navigate back
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${meal.name} added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving meal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Meal'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _isSaving
              ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
              : TextButton.icon(
                onPressed: _saveMeal,
                icon: const Icon(Icons.check),
                label: const Text('Save'),
              ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Photo Section
            _buildSectionHeader('Photo', PhosphorIcons.camera()),
            GestureDetector(
              onTap: _isImageLoading ? null : _pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child:
                    _isImageLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _imageFile != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                        : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PhosphorIcon(
                                PhosphorIcons.camera(),
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 24),

            // Basic Information Section
            _buildSectionHeader('Basic Information', PhosphorIcons.notepad()),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Meal Name *'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a meal name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: _inputDecoration('Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _buildDropdownField(
              label: 'Category',
              value: _selectedCategory,
              items: _categories,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            _buildDropdownField(
              label: 'Difficulty',
              value: _selectedDifficulty,
              items: _difficulties,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _preparationTimeController,
              decoration: _inputDecoration('Preparation Time (e.g., 30 mins)'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 24),

            // Nutrition Section
            _buildSectionHeader('Nutrition', PhosphorIcons.chartBar()),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _caloriesController,
                    decoration: _inputDecoration('Calories *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _proteinController,
                    decoration: _inputDecoration('Protein (g) *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _carbsController,
                    decoration: _inputDecoration('Carbs (g) *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _fatController,
                    decoration: _inputDecoration('Fat (g) *'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Portion & Weight Section
            _buildSectionHeader('Portion & Weight', PhosphorIcons.ruler()),
            _buildSliderSection(
              title: 'Weight (g)',
              value: _weight,
              min: 50,
              max: 1000,
              divisions: 19,
              onChanged: (value) {
                setState(() {
                  _weight =
                      value; // value is already a double, no need for round()
                });
              },
              valueLabel: '${_weight.round()} g', // Round only for display
            ),
            const SizedBox(height: 16),
            _buildSliderSection(
              title: 'Servings',
              value: _servingSize.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _servingSize = value.round();
                });
              },
              valueLabel: '$_servingSize',
            ),
            const SizedBox(height: 24),

            // Meal Types Section
            _buildSectionHeader(
              'Meal Types (Select at least one)',
              PhosphorIcons.clockAfternoon(),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children:
                  _mealTypes.map((type) {
                    final isSelected = _selectedMealTypes.contains(type);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(type.capitalize()),
                      onSelected: (_) => _toggleMealType(type),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.green,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      showCheckmark: false,
                      avatar:
                          isSelected
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 18,
                              )
                              : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color:
                              isSelected ? Colors.green : Colors.grey.shade300,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),

            // Ingredients Section
            _buildSectionHeader(
              'Ingredients (Required)',
              PhosphorIcons.hamburger(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: _inputDecoration(
                      'Add ingredient',
                    ).copyWith(hintText: 'e.g., 2 cups of rice'),
                    onChanged: (value) => _newIngredient = value,
                    onSubmitted: (_) => _addIngredient(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addIngredient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_ingredients.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingredients (${_ingredients.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._ingredients.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.green.shade800,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade300,
                              ),
                              onPressed: () => _removeIngredient(entry.key),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Add ingredients to your meal',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Recipe Section
            _buildSectionHeader(
              'Recipe Instructions',
              PhosphorIcons.cookingPot(),
            ),
            TextFormField(
              controller: _recipeController,
              decoration: _inputDecoration(
                'Step by step instructions',
              ).copyWith(
                hintText:
                    'Example: 1. Preheat oven to 350°F\n2. Mix ingredients...',
                alignLabelWithHint: true,
              ),
              maxLines: 8,
            ),
            const SizedBox(height: 32),

            // Submit Button
            _isSaving
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed: _saveMeal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'SAVE MEAL',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String valueLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                valueLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.green.shade100,
            thumbColor: Colors.white,
            overlayColor: Colors.green.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          PhosphorIcon(icon, size: 22, color: Colors.green.shade800),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(label),
      items:
          items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
    );
  }
}

// Helper extension
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
