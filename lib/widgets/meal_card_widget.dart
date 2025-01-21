import 'package:flutter/material.dart';
import 'package:agendiet/widgets/food_list_modal.dart';

class MealCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final List<Map<String, dynamic>> refeicoes; // Alterado para List<Map<String, dynamic>>
  final BuildContext context;

  const MealCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.refeicoes,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showFoodListModal(context, label);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 2)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.black54),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodListModal(BuildContext context, String label) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FoodListModal(refeicoes: refeicoes, periodo: label);
      },
    );
  }
}
