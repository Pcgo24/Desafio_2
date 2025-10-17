import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';

class FormularioProntuarioScreen extends StatefulWidget {
  final Prontuario? prontuario;
  const FormularioProntuarioScreen({super.key, this.prontuario});

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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.prontuario;
    if (p != null) {
      _pacienteCtrl.text = p.paciente;
      _descricaoCtrl.text = p.descricao;
      _data = p.data;
    }
  }

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
    setState(() => _isSaving = true);
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() => _isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faça login antes de salvar um prontuário.'),
        ),
      );
      return;
    }
    final prontuario = Prontuario(
      id: widget.prontuario?.id,
      paciente: _pacienteCtrl.text,
      descricao: _descricaoCtrl.text,
      data: _data,
    );
    if (prontuario.id == null) {
      try {
        await _service.adicionarProntuario(prontuario);
      } on FirebaseException catch (e) {
        setState(() => _isSaving = false);
        final msg = e.code == 'permission-denied'
            ? 'Sem permissão para salvar. Verifique as regras do Firestore ou autenticação.'
            : 'Erro ao salvar: ${e.message}';
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        return;
      } catch (e) {
        setState(() => _isSaving = false);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar')));
        return;
      }
    } else {
      try {
        await _service.atualizarProntuario(prontuario);
      } on FirebaseException catch (e) {
        setState(() => _isSaving = false);
        final msg = e.code == 'permission-denied'
            ? 'Sem permissão para atualizar. Verifique as regras do Firestore ou autenticação.'
            : 'Erro ao atualizar: ${e.message}';
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        return;
      } catch (e) {
        setState(() => _isSaving = false);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao atualizar')));
        return;
      }
    }
    setState(() => _isSaving = false);
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
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
