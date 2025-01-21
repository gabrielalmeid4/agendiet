import 'package:agendiet/views/add_meal_view.dart';
import 'package:agendiet/widgets/meal_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para converter a resposta JSON

class MealScheduleView extends StatelessWidget {
  final int userId;

  MealScheduleView({super.key, required this.userId});

  // Função para buscar planos alimentares
  Future<List<Map<String, dynamic>>> fetchMealPlans(int userId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/planos-alimentares/get/$userId'));

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, parse o JSON
      final List<dynamic> data = jsonDecode(response.body);
      print('Dados recebidos: ${response.body}');
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Falha ao carregar planos alimentares');
    }
  }

  @override
  Widget build(BuildContext context) {// Substitua pelo ID do usuário atual

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMealPlans(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum plano alimentar encontrado.'));
          } else {

            

final refeicoesManha = snapshot.data!
    .where((plano) {
      print('Periodo: ${plano['periodododia']}'); // Verifique o valor exato
      return plano['periodododia']?.toString().toLowerCase().trim() == 'manhã';
    })
    .toList();

final refeicoesTarde = snapshot.data!
    .where((plano) {
      print('Periodo: ${plano['periodododia']}'); // Verifique o valor exato
      return plano['periodododia']?.toString().toLowerCase().trim() == 'tarde';
    })
    .toList();

final refeicoesNoite = snapshot.data!
    .where((plano) {
      print('Periodo: ${plano['periodododia']}'); // Verifique o valor exato
      return plano['periodododia']?.toString().toLowerCase().trim() == 'noite';
    })
    .toList();



            return Container(
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
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMealScreen(userId: userId)),
          );
        },
        backgroundColor: Colors.green.shade400,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}