import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para converter a resposta JSON
import 'package:agendiet/views/add_meal_view.dart';
import 'package:agendiet/widgets/meal_card_widget.dart';

class MealScheduleView extends StatefulWidget {
  final int userId;

  MealScheduleView({super.key, required this.userId});

  @override
  _MealScheduleViewState createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  List<Map<String, dynamic>> mealPlans = [];

  // Função para buscar planos alimentares
  Future<void> fetchMealPlans() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/planos-alimentares/get/${widget.userId}'));

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, parse o JSON
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        mealPlans = data.map((item) => item as Map<String, dynamic>).toList();
      });
    } else {
      throw Exception('Falha ao carregar planos alimentares');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMealPlans();
  }

  @override
  Widget build(BuildContext context) {
    // Separando as refeições por período
    final refeicoesManha = mealPlans
        .where((plano) => plano['periodododia']?.toString().toLowerCase().trim() == 'm')
        .toList();
    final refeicoesTarde = mealPlans
        .where((plano) => plano['periodododia']?.toString().toLowerCase().trim() == 't')
        .toList();
    final refeicoesNoite = mealPlans
        .where((plano) => plano['periodododia']?.toString().toLowerCase().trim() == 'n')
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detalhes',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: mealPlans.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    MealCard(icon: Icons.wb_sunny, label: 'Manhã', color: Colors.green.shade200, refeicoes: refeicoesManha, context: context),
                    const SizedBox(height: 16),
                    MealCard(icon: Icons.sunny, label: 'Tarde', color: Colors.orange.shade200, refeicoes: refeicoesTarde, context: context),
                    const SizedBox(height: 16),
                    MealCard(icon: Icons.nightlight_round, label: 'Noite', color: Colors.purple.shade200, refeicoes: refeicoesNoite, context: context),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para a tela de adicionar refeição
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMealScreen(userId: widget.userId)),
          );

          // Verifica se a refeição foi adicionada com sucesso e atualiza a lista de refeições
          if (result != null && result == true) {
            fetchMealPlans(); // Atualiza os planos de refeição
          }
        },
        backgroundColor: Colors.green.shade400,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
