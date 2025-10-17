import 'package:flutter/material.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';
import 'formulario_prontuario_screen.dart';

class ProntuarioListScreen extends StatelessWidget {
  ProntuarioListScreen({super.key});

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prontuários')),
      body: StreamBuilder<List<Prontuario>>(
        stream: firestoreService.getProntuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final prontuarios = snapshot.data ?? [];
          if (prontuarios.isEmpty) {
            return const Center(child: Text('Nenhum prontuário encontrado.'));
          }

          return ListView.builder(
            itemCount: prontuarios.length,
            itemBuilder: (context, index) {
              final p = prontuarios[index];
              return ListTile(
                title: Text(p.paciente),
                subtitle: Text(p.descricao),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => firestoreService.deletarProntuario(p.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormularioProntuarioScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
