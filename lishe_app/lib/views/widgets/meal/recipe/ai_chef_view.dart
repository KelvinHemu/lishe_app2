import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../models/meal.dart';

class AiChefView extends StatefulWidget {
  final Meal meal;

  const AiChefView({super.key, required this.meal});

  @override
  State<AiChefView> createState() => _AiChefViewState();
}

class _AiChefViewState extends State<AiChefView> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isTyping = true;
      _messageController.clear();
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(text: _getAIResponse(text), isUser: false));
      });
    });
  }

  String _getAIResponse(String question) {
    // Simple response logic based on keywords
    final lowerQuestion = question.toLowerCase();
    if (lowerQuestion.contains('substitute') ||
        lowerQuestion.contains('alternative')) {
      return 'For ${widget.meal.name}, you can try these healthy substitutions:\n'
          '• Use whole grain flour instead of refined flour\n'
          '• Replace sugar with honey or maple syrup\n'
          '• Try Greek yogurt instead of cream';
    } else if (lowerQuestion.contains('time') ||
        lowerQuestion.contains('how long')) {
      return 'The recommended cooking time for ${widget.meal.name} is ${widget.meal.preparationTime}. '
          'Make sure to check for doneness while cooking.';
    } else {
      return 'I\'m here to help with cooking ${widget.meal.name}! You can ask about ingredients, '
          'cooking times, or substitutions.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chat Section - Moved to top
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PhosphorIcon(
                    PhosphorIcons.chatCircleDots(),
                    size: 20,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ask AI Chef',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_messages.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _messages[index],
                  ),
                ),
              if (_isTyping)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      PhosphorIcon(
                        PhosphorIcons.robot(),
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI Chef is typing...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about cooking tips...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.blue.shade200),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: PhosphorIcon(
                      PhosphorIcons.paperPlaneTilt(),
                      size: 20,
                      color: Colors.blue.shade700,
                    ),
                    onPressed: () => _handleSubmitted(_messageController.text),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Cooking Tips Section
        _buildSection(
          title: 'Smart Cooking Tips',
          icon: PhosphorIcons.lamp(),
          content: [
            'Prep all ingredients before starting to cook for better efficiency',
            'For best results, cook ${widget.meal.name.toLowerCase()} on medium heat',
            'Let ingredients reach room temperature before cooking',
            'Use fresh ingredients for optimal flavor',
          ],
        ),

        const SizedBox(height: 20),

        // Ingredient Substitutions
        _buildSection(
          title: 'Healthy Substitutions',
          icon: PhosphorIcons.lightbulb(),
          content: _getSubstitutions(widget.meal.ingredients),
        ),

        const SizedBox(height: 20),

        // Nutrition Insights
        _buildSection(
          title: 'Nutrition Insights',
          icon: PhosphorIcons.chartBar(),
          content: [
            'This meal is rich in protein (${widget.meal.protein}g) and provides sustained energy',
            'Contains healthy fats from natural sources',
            'Good source of complex carbohydrates',
            'Consider portion size to maintain calorie goals (${widget.meal.calories} kcal/serving)',
          ],
        ),

        const SizedBox(height: 20),

        // Pro Tips
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pro Tip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'For better results, marinate ingredients for at least 30 minutes before cooking ${widget.meal.name.toLowerCase()}.',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<String> content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PhosphorIcon(icon, size: 20, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...content.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getSubstitutions(List<String> ingredients) {
    // This could be enhanced with a more sophisticated substitution logic
    return ingredients.map((ingredient) {
      switch (ingredient.toLowerCase()) {
        case 'rice':
          return 'Replace rice with quinoa for more protein';
        case 'sugar':
          return 'Use honey or stevia as a natural sweetener';
        case 'oil':
        case 'vegetable oil':
          return 'Try olive oil or avocado oil for healthy fats';
        default:
          return 'Consider whole grain alternatives for $ingredient';
      }
    }).toList();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            PhosphorIcon(
              PhosphorIcons.robot(),
              size: 16,
              color: Colors.blue.shade700,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isUser ? Colors.blue.shade900 : Colors.black87,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            PhosphorIcon(
              PhosphorIcons.user(),
              size: 16,
              color: Colors.blue.shade700,
            ),
          ],
        ],
      ),
    );
  }
}
