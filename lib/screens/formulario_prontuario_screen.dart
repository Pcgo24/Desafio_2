import 'package:flutter/material.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';

class FormularioProntuarioScreen extends StatefulWidget {
  const FormularioProntuarioScreen({super.key});

  @override
  State<FormularioProntuarioScreen> createState() =>
      _FormularioProntuarioScreenState();
}

class _FormularioProntuarioScreenState
    extends State<FormularioProntuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();
  DateTime _data = DateTime.now();
  final FirestoreService _service = FirestoreService();

  @override
  void dispose() {
    _pacienteCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _data) {
      setState(() => _data = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final prontuario = Prontuario(
      paciente: _pacienteCtrl.text,
      descricao: _descricaoCtrl.text,
      data: _data,
    );
    await _service.adicionarProntuario(prontuario);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Prontuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pacienteCtrl,
                decoration: const InputDecoration(labelText: 'Paciente'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o paciente' : null,
              ),
              TextFormField(
                controller: _descricaoCtrl,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a descrição' : null,
              ),
              Row(
                children: [
                  Text(
                    'Data: ${_data.toLocal().toIso8601String().split('T').first}',
                  ),
                  TextButton(
                    onPressed: _selectDate,
                    child: const Text('Selecionar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _save, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
