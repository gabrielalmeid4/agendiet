import 'package:flutter/material.dart';
import 'package:agendiet/domain/entities/meta_peso.dart';

class AddMetaView extends StatefulWidget {
  const AddMetaView({super.key});

  @override
  _AddMetaViewState createState() => _AddMetaViewState();
}

class _AddMetaViewState extends State<AddMetaView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _pesoPretendidoController = TextEditingController();
  DateTime? _dataInicio;
  DateTime? _dataLimite;

  void _saveMeta() {
    if (_formKey.currentState!.validate()) {
      if (_dataInicio == null || _dataLimite == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Defina as datas de início e limite')),
        );
        return;
      }

      final newMeta = MetaPeso(
        id: DateTime.now().toString(),
        idUsuario: 'usuario123',
        pesoPretendido: double.parse(_pesoPretendidoController.text),
        dataInicio: _dataInicio!,
        dataLimite: _dataLimite!,
        foiAtingido: false,
      );

      print(
          'Nova meta: ${newMeta.pesoPretendido} kg, Data Limite: ${newMeta.dataLimite}');
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, 
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, 
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _dataInicio = pickedDate;
        } else {
          _dataLimite = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Adicionar Meta',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _pesoPretendidoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Peso Pretendido',
                  hintText: 'Digite o peso desejado (kg)',
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O peso pretendido é obrigatório';
                  }
                  final peso = double.tryParse(value);
                  if (peso == null || peso <= 0) {
                    return 'Digite um peso válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Data de Início'),
                subtitle: Text(
                  _dataInicio == null
                      ? 'Selecione uma data'
                      : '${_dataInicio!.day}/${_dataInicio!.month}/${_dataInicio!.year}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Data Limite'),
                subtitle: Text(
                  _dataLimite == null
                      ? 'Selecione uma data'
                      : '${_dataLimite!.day}/${_dataLimite!.month}/${_dataLimite!.year}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveMeta,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
