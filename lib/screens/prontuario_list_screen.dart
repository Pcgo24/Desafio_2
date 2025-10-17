import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';
import 'formulario_prontuario_screen.dart';

class ProntuarioListScreen extends StatelessWidget {
  ProntuarioListScreen({super.key, FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prontuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por paciente',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => (context as Element).markNeedsBuild(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () async {
                    final from = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 30),
                      ),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (from == null) return;
                    final to = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: from,
                      lastDate: DateTime(2100),
                    );
                    if (to == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _FilteredResultsScreen(
                          byDateRange: true,
                          from: from,
                          to: to,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Prontuario>>(
              stream: _searchCtrl.text.trim().isEmpty
                  ? _firestoreService.getProntuarios()
                  : _firestoreService.queryByPaciente(_searchCtrl.text.trim()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final prontuarios = snapshot.data ?? [];
                if (prontuarios.isEmpty) {
                  return const Center(
                    child: Text('Nenhum prontuário encontrado.'),
                  );
                }

                return ListView.builder(
                  itemCount: prontuarios.length,
                  itemBuilder: (context, index) {
                    final p = prontuarios[index];
                    return ListTile(
                      title: Text(p.paciente),
                      subtitle: Text(
                        '${p.descricao}\n${p.data.toLocal().toIso8601String().split('T').first}',
                      ),
                      isThreeLine: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FormularioProntuarioScreen(prontuario: p),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _firestoreService.deletarProntuario(p.id!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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

class _FilteredResultsScreen extends StatelessWidget {
  final bool byDateRange;
  final DateTime? from;
  final DateTime? to;

  const _FilteredResultsScreen({
    Key? key,
    this.byDateRange = false,
    this.from,
    this.to,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();
    final stream = (byDateRange && from != null && to != null)
        ? service.queryByDateRange(from!, to!)
        : service.getProntuarios();

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados filtrados')),
      body: StreamBuilder<List<Prontuario>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError)
            return Center(child: Text('Erro: ${snapshot.error}'));
          final items = snapshot.data ?? [];
          if (items.isEmpty)
            return const Center(child: Text('Nenhum registro.'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final p = items[i];
              return ListTile(
                title: Text(p.paciente),
                subtitle: Text(
                  '${p.descricao}\n${p.data.toLocal().toIso8601String().split('T').first}',
                ),
                isThreeLine: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FormularioProntuarioScreen(prontuario: p),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
